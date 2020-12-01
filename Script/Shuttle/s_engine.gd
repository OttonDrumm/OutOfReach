extends Node2D

signal collision_detected

const shuttle_piece_type = preload("res://Scenes/Shuttle/ShuttlePiece.tscn")
const shuttle_piece_script = preload("res://Script/Shuttle/s_shuttle_piece.gd")

export var chapter = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func build(_head_position):
	if !MPieceManager.engines.has(chapter):
		return
	clear()
	var engine = MPieceManager.engines[chapter]
	for p in engine.pieces:
		var piece = shuttle_piece_type.instance()
		piece.from_building_piece(engine.pieces[p])
		piece.position = _head_position+engine.pieces[p].position
		add_child(piece)
		#piece.connect("collision_detected", self, "_detect_collision")
		
	if MPlayerManager.chapter == chapter:
		show()
	else:
		hide()

func clear():
	for c in get_children():
		if c is shuttle_piece_script:
			remove_child(c)
			c.queue_free()

func _detect_collision(_id, _layer):
	emit_signal("collision_detected", _id, _layer)
