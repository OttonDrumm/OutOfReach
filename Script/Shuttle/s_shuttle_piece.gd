extends Area2D

signal collision_detected

const head_piece = preload("res://Scenes/Pieces/Head.tscn")
const fire_scene = preload("res://Scenes/Pieces/Fire.tscn")
const collision_name = "Collision"
const fire_name = "Fire"

export var is_head = false
export var is_propulsor = false
var invulnerability = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	MPlayerManager.connect("set_invulnerability",self,"set_invulnerability_for")
	if !is_head:
		#$Sprite.texture = Texture.new()
		$Sprite.scale = Vector2.ONE
		#var collision = get_node_or_null(collision_name)
		#if collision:
		#	collision.queue_free()
		#	remove_child(collision)
	pass # Replace with function body.

func from_building_piece(_piece):
	if is_head:
		return
	$Sprite.texture = _piece.texture
	if _piece.flipped:
		scale *= Vector2(-1,1)
	var collision = get_node_or_null(collision_name)
	#f collision:
		#collision.queue_free()
	if _piece.shape_class == "CollisionShape2D":
		collision = CollisionShape2D.new()
	elif _piece.shape_class == "CollisionPolygon2D":
		collision = CollisionPolygon2D.new()
	#var shape = _piece.collision
	if collision and _piece.shape:
		#var dup = shape.duplicate(DUPLICATE_USE_INSTANCING)
		if collision is CollisionShape2D:
			collision.shape = _piece.shape
		elif collision is CollisionPolygon2D:
			collision.polygon = _piece.shape
	if MPieceManager.is_propusor(_piece):
		is_propulsor = true
		var fire = fire_scene.instance()
		fire.name = fire_name
		fire.set_engine(_piece.id)
		add_child(fire)
	else:
		is_propulsor = false
		
func _on_ShuttlePiece_area_shape_entered(area_id, area, area_shape, self_shape):
	emit_signal("collision_detected", area_id, area.collision_layer)
	pass # Replace with function body.

func set_vulnerable():
	var collision = get_node_or_null(collision_name)
	if collision: collision.disabled = false

func set_invulnerability_for(_time):
	var collision = get_node_or_null(collision_name)
	if collision and !collision.disabled:
		#TODO fare in modo che i sight layer funzionino comunque, usare collision_mask
		collision.disabled = true
		invulnerability = _time
		set_process(true)

func _process(delta):
	if invulnerability > 0:
		invulnerability-= delta
	else:
		call_deferred("set_vulnerable")
		set_process(false)
