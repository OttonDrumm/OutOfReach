extends Node

signal change_volume
signal mute_volume

var volume = 0
var min_volume = -30
var max_volume = 12
var muted_volume = -80
var interval = 3
var muted = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_volume (_increase=true):
	if _increase:
		if muted:
			volume = min_volume
		elif volume < max_volume:
			volume += interval
	elif volume > min_volume:
		volume -= interval
	else:
		mute_volume()
	emit_signal("change_volume")

func mute_volume():
	if !muted:
		muted = true
		volume = muted_volume

