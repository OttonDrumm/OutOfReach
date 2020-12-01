extends Node

const curr_scene_name = "CurrentScene"
const level_names = {
	1: "Level1"
}
var level1_playing = false
var offset = Vector2(-1600,-900)
# Called when the node enters the scene tree for the first time.
func _ready():
	MSceneLoader.connect("load_scene", self, "goto_scene")
	MPlayerManager.connect("update_camera_position", self, "follow_camera")
	$Tween.interpolate_property($Transition,"self_modulate:a", 1, 0, MSceneLoader.transition_time, Tween.TRANS_LINEAR, Tween.EASE_IN, MSceneLoader.transition_time)
	$Tween.start()
	pass # Replace with function body.

func update_position():
	var pos = get_viewport().get_canvas_transform().get_origin()
	$Transition.rect_position = -pos
	$Back.rect_position = -pos
	

func goto_scene(_scene, _in_time = null, _out_time = null):
	if _scene == null:
		return
	if _in_time == null:
		_in_time = MSceneLoader.transition_time
	if _out_time == null:
		_out_time = MSceneLoader.transition_time
	update_position()
	handle_audio(_scene.name, _in_time)
	$Tween.interpolate_property($Transition,"self_modulate:a", 0, 1, _in_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.interpolate_callback(self, _in_time, "load_scene", _scene)
	$Tween.interpolate_callback(self, _in_time, "update_position")
	$Tween.interpolate_property($Transition,"self_modulate:a", 1, 0, _out_time, Tween.TRANS_LINEAR, Tween.EASE_IN, _in_time)
	$Tween.start()

func load_scene(_scene):
	$Menu.show()
	get_tree().paused = false
	var s = get_node_or_null(curr_scene_name)
	if s != null:
		for c in s.get_children():
			c.queue_free()
			s.remove_child(c)
	#_scene.name = curr_scene_name
		s.add_child(_scene)

func load_building_scene():
	$Menu.show()
	MSceneLoader.load_building_scene()

func load_main_menu():
	#$Menu.show()
	MSceneLoader.load_main_menu()
	
func load_launch_scene():
	MSceneLoader.load_current_launch()
	$Menu.hide()

func handle_audio(_scene_name, _time):
	if _scene_name == level_names[1]:
		if !level1_playing:
			$AudioLevel/Level1.volume_db = MAudioManager.muted_volume
			$AudioLevel/Tween.interpolate_property($AudioLevel/Level1, "volume_db", MAudioManager.muted_volume, MAudioManager.volume, _time,Tween.TRANS_LINEAR,Tween.EASE_IN)
			$AudioLevel/Tween.start()
			$AudioLevel/Level1.play()
			level1_playing = true
	elif level1_playing:
		$AudioLevel/Tween.interpolate_property($AudioLevel/Level1, "volume_db", $AudioLevel/Level1.volume_db, MAudioManager.muted_volume, _time,Tween.TRANS_LINEAR,Tween.EASE_IN)
		$AudioLevel/Tween.interpolate_callback($AudioLevel/Level1, _time, "stop")
		$AudioLevel/Tween.start()
		level1_playing = false

### EVENTS ###

func _on_next_chapter_pressed():
	MPlayerManager.go_to_next_chapter()

func _on_prev_chapter_pressed():
	MPlayerManager.go_to_prev_chapter()

func _on_add_fuel_pressed():
	MStatManager.update_stat("fuel", MPieceManager.current_engine, 1, true)
	MProgressManager.update_progress(1)

func follow_camera(_pos):
	$Transition.rect_position = _pos+offset
	$Back.rect_position = _pos+offset
