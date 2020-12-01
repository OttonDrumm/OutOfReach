extends Node2D

signal change_engine

var map = {
	'1_1': {
		'engine': 1
	},
	'1_2': {
		'engine': 1,
		'next': '2_2'
	},
	'1_3': {
		'engine': 1,
		'next': '2_3'
	},
	'2_2': {
		'engine': 2,
		'prev': '1_2'
	},
	'2_3': {
		'engine': 2,
		'prev': '1_3',
		'next': '3_3'
	},
	'3_3': {
		'engine': 3,
		'prev': '2_3'
	}
}
var current = '1_1'
var mouse_in = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_current(_state):
	current = _state
	if !map.has(current):
		current = '1_'+str(MPlayerManager.chapter)
	emit_signal("change_engine", map[current].engine)
	$Sprite.play(current)

func _input(event):
	if mouse_in and event is InputEventMouseButton and event.is_pressed() and event.get_button_index() == BUTTON_LEFT:
		if mouse_in == 'prev':
			if map[current].has('prev'):
				set_current(map[current].prev)
		elif mouse_in == 'next':
			if map[current].has('next'):
				set_current(map[current].next)

func _on_Prev_mouse_entered():
	mouse_in = "prev"

func _on_Next_mouse_entered():
	mouse_in = "next"

func _on_mouse_exited():
	mouse_in = false
