extends Node

signal stats_updated

var stats = {}
var max_stats = {
	1: {
		'fuel': 5,
		'shield': 3,
		'speed': 5,
		'manovrability': 5
	},
	2: {
		'fuel': 10,
		'shield': 10,
		'speed': 20,
		'manovrability': 10
	},
	3: {
		'fuel': 20,
		'shield': 20,
		'speed': 30,
		'manovrability': 15
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_stats()
	pass # Replace with function body.

func reset_stats():
	stats = {
		'fuel': [0,0,0,0],
		'max_fuel': [0,0,0,0],
		'shield': [0,0,0,0],
		'manovrability': [1.5,1.5,1.5,1.5],
		'speed': [0,0,0,0]
	}
	emit_signal("stats_updated")

func update_stat(_stat, _engine, _value, _is_add, _update_view = true):
	if stats.has(_stat):
		if _is_add:
			stats[_stat][_engine] += _value
		else:
			stats[_stat][_engine] -= _value
			
		var m = get_max_stat(_engine, _stat)
		if m >= 0:
			if stats[_stat][_engine] > m:
				stats[_stat][_engine] = m
			elif stats[_stat][_engine] < 0:
				stats[_stat][_engine] = 0
		
		for s in stats:
			stats[s][0] = stats[s][1] + stats[s][2] + stats[s][3]
		if _update_view:
			emit_signal("stats_updated")

func update_piece_stats(_piece, _is_add):
	if _piece and _piece.stats:
		for s in _piece.stats:
			update_stat(s, _piece.engine, _piece.stats[s], _is_add, false)
	emit_signal("stats_updated")
	
func get_max_stat(_engine, _type, _global = false):
	var m = max_stats[_engine]
	if m.has(_type):
		if _global and _engine > 1:
			return m[_type] + get_max_stat(_engine-1, _type)
		else:
			return m[_type]
	return -1
