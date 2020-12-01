extends Node2D

signal dropped

const piece_type = preload('res://Script/s_piece.gd')

onready var engines = {
	1: $Pieces1,
	2: $Pieces2,
	3: $Pieces3
}

onready var drop_audio = {
	"from": 1,
	"to": 4,
	1: $Audio/DropPiece1,
	2: $Audio/DropPiece2,
	3: $Audio/DropPiece3,
	4: $Audio/DropPiece4
}
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	MPlayerManager.connect("chapter_changed", self, "_on_chapter_change")
	MPieceManager.connect("switch_engine", self, "show_selected_engine")
	_on_chapter_change()
	load_pieces()
	
func load_pieces():
	for n in range(1,MPlayerManager.chapter+1):
		for c in engines[n].get_children():
			if (c is piece_type):
				engines[n].remove_child(c)
				c.queue_free()
		MStatManager.reset_stats()
		for k in MPieceManager.engines[n].pieces:
			var p = MPieceManager.engines[n].pieces[k]
			if p.object:
				p.object.queue_free()
			p.object = MPieceManager.get_piece(p.type, p.id, true)
			p.object.set_flipped(p.flipped)
			p.object.index = k
			add_static_piece(p.object, n, p.position+$Head.global_position)
			MStatManager.update_piece_stats(p.object, true)

func _on_chapter_change():
	$Paper.set_current(str(MPieceManager.current_engine) + '_'+ str(MPlayerManager.chapter))
	show_selected_engine()

func show_selected_engine():
	for e in engines:
		if e == MPieceManager.current_engine:
			engines[e].show()
		else:
			engines[e].hide()
	for b in $Border.get_children():
		b.disabled = (b.name != str(MPieceManager.current_engine))
	for a in $Area.get_children():
		a.disabled = (a.name != str(MPieceManager.current_engine))

func add_piece(_piece):
	engines[MPieceManager.current_engine].add_child(_piece)
	_piece.engine = MPieceManager.current_engine
	_piece.set_global_position(get_viewport().get_mouse_position())
	_piece.connect("dropped", self, "drop_piece")
	
func add_static_piece (_piece, _engine, _position):
	engines[_engine].add_child(_piece)
	_piece.engine = _engine
	_piece.set_global_position(_position)
	_piece.connect("dropped", self, "drop_piece")

func is_piece_inside(_piece):
	return $Area.overlaps_area(_piece)
	
func is_piece_valid(_piece):
	return is_piece_inside(_piece) and !$Border.overlaps_area(_piece)

func drop_piece(_piece):
	var inside = is_piece_inside(_piece)
	var piece_already_added = MPieceManager.has_piece(_piece, MPieceManager.current_engine)
	if (inside):
		play_random_drop_piece()
		_piece.set_valid(is_piece_valid(_piece))
		MPieceManager.add_piece_to(_piece, 
			_piece.global_position-$Head.global_position, 
			MPieceManager.current_engine)
		if !piece_already_added:
			MStatManager.update_piece_stats(_piece, true)
			#emit_signal("update_stats", _piece, true)
	else:
		engines[MPieceManager.current_engine].remove_child(_piece)
		MPieceManager.remove_piece_from(_piece, MPieceManager.current_engine)
		if piece_already_added:
			MStatManager.update_piece_stats(_piece, false)
			#emit_signal("update_stats", _piece, false)


func _on_Paper_change_engine(_engine):
	MPieceManager.switch_engine(_engine)

func play_random_drop_piece():
	rng.randomize()
	var i = rng.randi_range(drop_audio.from, drop_audio.to)
	drop_audio[i].play()
