extends Node2D

var player_in
var damage = 1
var fragment_in = [2, 3, 4, 5]
var final_frame = 0
var played = false
var last_collision_activated = false
export var use_final_spawn_position = true
export var final_fragments = ["lg", "md", "md", "sm", "sm", "sm"]
export var middle_fragments = ["sm","sm", "xs", "xs", "xs"]
export var speed_scale = 1.0

var is_init = false

export var spawn_all = false
var fragment_count = 0
var fragment_current = 0

func _ready():
	set_process(false)
	$Area/Sprite.play("default")
	$Area/Sprite.stop()
	var ref_path = get_node_or_null("ReferencePath")
	if ref_path and ref_path.curve:
		$FragmentSpawn.set_curve(ref_path.curve)
	final_frame = $Area/Sprite.frames.get_frame_count("activate")-1
	fragment_count = $Area/FragmentPath.curve.get_point_count()
	fragment_current = 0
	$Area/Sprite.speed_scale = speed_scale
	is_init = true
	pass # Replace with function body.

func _on_Sight_area_shape_entered(area_id, area, area_shape, self_shape):
	player_in = true
	if !played:
		$Area/Sprite.play("activate")
		$AudioStreamPlayer2D.play()
		played = true


func _on_Area_area_shape_entered(area_id, area, area_shape, self_shape):
	MPlayerManager.emit_signal("inflict_damage", damage)


func _on_Sprite_frame_changed():
	if !is_init:
		return
	if spawn_all or $Area/Sprite.frame in fragment_in:
		#$FragmentSpawn.spawn(["sm","sm", "xs", "xs", "xs"])
		$FragmentSpawn.spawn(middle_fragments, $Area/FragmentPath.curve.get_point_position(fragment_current) - $FragmentSpawn.position )
		fragment_current += 1
	if $Area/Sprite.frame == final_frame:
		$FragmentSpawn.sudden = true
		$FragmentSpawn.spawn(final_fragments, $Area/FragmentPath.curve.get_point_position(fragment_current) - $FragmentSpawn.position )
		fragment_current += 1
		#if use_final_spawn_position:
		#	$FragmentSpawn.spawn(final_fragments, $FinalSpawn.position - $FragmentSpawn.position)
		#else:
		#	$FragmentSpawn.spawn(final_fragments)
		$Area/Sprite.stop()
	activate_collision($Area/Sprite.frame)
	pass # Replace with function body.

func activate_collision(_frame):
	var collision = $Area.get_node_or_null("Collision_"+str(_frame))
	if collision:
		if last_collision_activated:
			last_collision_activated.disabled = true
		collision.disabled = false
		last_collision_activated = collision

func _on_Sprite_animation_finished():
	#$FragmentSpawn.spawn()
	pass # Replace with function body.
