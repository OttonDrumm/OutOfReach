extends Area2D

signal dropped

onready var collision = $Collision
onready var sprite = $Sprite

export var stats = {
	'max_fuel': 0.0,
	'shield': 0.0,
	'speed': 0.0,
	'manovrability': 0.0
}

var overlapping = false
var valid = true

var mouse_in = false
var dragging = false
export var disable_drag = false

var flipped = false
var target_position = Vector2.ZERO
var engine = 1
export var is_head = false

var type
var id
var index = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("area_shape_entered", self, "_on_Piece_area_shape_entered")
	self.connect("area_shape_exited", self, "_on_Piece_area_shape_exited")
	self.connect("mouse_entered", self, "_mouse_entered")
	self.connect("mouse_exited", self, "_mouse_exited")
	refresh_colors()
	pass # Replace with function body.

func setup(_create_static):
	dragging = !disable_drag && !_create_static

func set_valid(_value):
	valid = _value
	refresh_colors()

func refresh_colors():
	if valid and !overlapping:
		modulate = Color.white
	else:
		modulate = Color.red.lightened(0.5)
	if dragging:
		modulate.a = 0.7
	else:
		modulate.a = 1

func set_flipped (_value):
	if flipped != _value:
		scale*=Vector2(-1,1)
	flipped = _value

func set_global_position (_position):
	global_position = _position
	target_position = position #usa position non _position

func _input(event):
	if !disable_drag:
		if event is InputEventMouseButton and event.is_pressed():
			if event.get_button_index() == BUTTON_LEFT:
				if !dragging:
					if mouse_in:
						dragging = true
						refresh_colors()
						get_tree().set_input_as_handled()
				else:
					emit_signal("dropped",self)
					dragging = false
					refresh_colors()
			elif mouse_in and event.get_button_index() == BUTTON_RIGHT:
				set_flipped(!flipped)
				get_tree().set_input_as_handled()
				if !dragging:
					emit_signal("dropped",self)
				#rotation_degrees += 90
		if dragging and event is InputEventMouseMotion:
			target_position += event.relative
			$Tween.interpolate_property(self, "position", position, target_position, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()

func _mouse_entered():
	mouse_in = true

func _mouse_exited():
	mouse_in = false

func _on_Piece_area_shape_entered(area_id, area, area_shape, self_shape):
	if (area.get_script() == get_script() 
		and (is_head or area.engine == engine)):
		overlapping = true
		refresh_colors()

func _on_Piece_area_shape_exited(area_id, area, area_shape, self_shape):
	if (area.get_script() == get_script() 
		and (is_head or area.engine == engine)):
		overlapping = false
		refresh_colors()
