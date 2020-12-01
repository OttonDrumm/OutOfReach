extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	pass # Replace with function body.

func _on_Shuttle_die():
	show()

func _on_RetryButton_pressed():
	MSceneLoader.load_current_launch()

func _on_BuildButton_pressed():
	MSceneLoader.load_building_scene()
