extends Node2D

const speed_factor = 30
export var speed = 2
export var follow_player = false
export var follow_time = -1
export var use_lifespan = false
export var lifespan = -1
export var damage = 1
var player_in = false
var last_lap = false
var lap_offset = 0
onready var follow = $Path2D/PathFollow2D

func _ready():
	set_process(false)
	if follow_player:
		last_lap = true
		hide()
		$Path2D/PathFollow2D/H/Collision.call_deferred("set_disabled", true)

func _process(delta):
	if use_lifespan:
		lifespan -= delta
		if lifespan <= 0:
			use_lifespan = false
			last_lap = true
	if !use_lifespan and last_lap:
		lap_offset += speed*delta/speed_factor
		if lap_offset >= 1:
			queue_free()
	follow.set_unit_offset(follow.get_unit_offset()+speed*delta/speed_factor)
	if follow_player and follow_time > 0:
		follow_time -= delta
		position.y = MPlayerManager.player_pos.y



func _on_Sight_area_shape_entered(area_id, area, area_shape, self_shape):
	player_in = true
	show()
	$Path2D/PathFollow2D/H/Collision.call_deferred("set_disabled", false)
	set_process(true)
	pass # Replace with function body.


func _on_Sight_area_exited(area):
	if (player_in):
		last_lap = true
		lap_offset = 0
	player_in = false

func _on_H_area_shape_entered(area_id, area, area_shape, self_shape):
	MPlayerManager.emit_signal("inflict_damage", damage)
