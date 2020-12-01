extends Node

signal progress_changed

var progress = {
	1: {
		"value": 0,
		"max_val": 15
	},
	2: {
		"value": 0,
		"max_val": 15
	},
	3: {
		"value": 0,
		"max_val": 15
	}
}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	MPlayerManager.connect("chapter_changed", self, "update_progress")
	pass # Replace with function body.

func update_progress(_value = 0):
	if _value != 0:
		progress[MPlayerManager.chapter].value += _value
		if get_progress() > get_max_progress():
			progress[MPlayerManager.chapter].value = get_max_progress()
		elif get_progress() < 0:
			progress[MPlayerManager.chapter].value = 0	
	emit_signal("progress_changed")

func get_progress():
	return progress[MPlayerManager.chapter].value
	
func get_max_progress():
	return progress[MPlayerManager.chapter].max_val
