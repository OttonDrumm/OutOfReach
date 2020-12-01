extends Node

signal switch_engine

const global_scale = 0.2
var rng = RandomNumberGenerator.new()
const base_path = "res://Scenes/Pieces/<type>_<id>.tscn"
var types = ["Fuel", "Plate", "Propulsor", "Wing"]
var engines = {
	1: {
		"pieces": {}
	},
	2: {
		"pieces": {}
	},
	3: {
		"pieces": {}
	}
}
var piece_index_mutex = Mutex.new()
var piece_index = 0

var current_engine = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_unique_index():
	piece_index_mutex.lock()
	var i = piece_index
	piece_index_mutex.unlock()
	piece_index += 1
	return i

func add_piece_to(_piece, _relative_position, _engine):
	if engines.has(_engine):
		if _piece.index < 0:
			_piece.index = get_unique_index()
			engines[_engine].pieces[_piece.index] = {
				"object": _piece,
				"position": _relative_position,
				"type": _piece.type,
				"id": _piece.id,
				"flipped": _piece.flipped,
				"texture": _piece.sprite.texture,
				"shape": get_area_shape(_piece),
				"shape_class": get_area_shape_class(_piece)
			}
		else:
			engines[_engine].pieces[_piece.index].position = _relative_position
			engines[_engine].pieces[_piece.index].flipped = _piece.flipped

func remove_piece_from(_piece, _engine):
	if engines.has(_engine) and engines[_engine].pieces.has(_piece.index):
		engines[_engine].pieces.erase(_piece.index)

func get_area_shape(_area):
	var c = _area.get_node("Collision")
	if (c is CollisionShape2D):
		return c.shape
	elif (c is CollisionPolygon2D):
		return c.polygon

func get_area_shape_class(_area):
	var c = _area.get_node("Collision")
	if (c is CollisionShape2D):
		return "CollisionShape2D"
	elif (c is CollisionPolygon2D):
		return "CollisionPolygon2D"

func get_piece(_type, _id, _static = false):
	var path = base_path.replace("<type>", _type)
	path = path.replace("<id>", _id)
	var piece = load(path).instance()
	piece.setup(_static)
	piece.type = _type
	piece.id = _id
	return piece

func get_new_piece(_chapter, _piece_index, _static = false):
	if !engines.has(_chapter):
		return null
	if !engines[_chapter].pieces.has(_piece_index):
		return null
	var piece = engines[_chapter].pieces[_piece_index].duplicate(DUPLICATE_USE_INSTANCING)
	piece.object = get_piece(piece.type, piece.id, _static)
	return piece

func has_piece(_piece, _engine):
	return _piece and engines.has(_engine) and engines[_engine].pieces.has(_piece.index)

func switch_engine(_engine):
	current_engine = _engine
	emit_signal("switch_engine")

func is_propusor(_piece):
	return _piece.type == types[2]
