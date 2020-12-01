extends Node

signal load_scene

var building_scene = preload('res://Scenes/Building/Building.tscn')
var main_menu_scene = preload('res://Scenes/MainMenu.tscn')
var launch_scene = preload("res://Scenes/Shuttle/Launch.tscn")
var finale_scene = preload("res://Scenes/Levels/Level1/Finale.tscn")
var level_scene = {
	1: preload("res://Scenes/Levels/Level1/Level1.tscn")
}
const transition_time = 1

func _ready():
	pass # Replace with function body.


func load_building_scene():
	emit_signal("load_scene", building_scene.instance())

func load_main_menu():
	emit_signal("load_scene", main_menu_scene.instance())

func load_current_launch():
	emit_signal("load_scene", level_scene[MPlayerManager.chapter].instance())

func load_launch_scene():
	emit_signal("load_scene", launch_scene.instance())
	
func load_finale(_in_time = null, _out_time = null):
	emit_signal("load_scene", finale_scene.instance(), _in_time, _out_time)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
