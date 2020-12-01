extends Node2D

signal start_ending

var ending_id
var first_point_shuttle
var first_point_camera
var move_to_duration = 5
var ending_duration = 10
var shuttle
var level_camera #level_camera
var trigger = false

# Called when the node enters the scene tree for the first time.
func _ready():
	MPlayerManager.connect("target_reached",self, "start_ending")
	first_point_shuttle = $StartingPoint.position
	first_point_camera = $StartingPoint.position
	pass # Replace with function body.

func set_shuttle(_shuttle):
	shuttle = _shuttle
	set_level_camera(shuttle.camera)
	
func set_level_camera(_camera):
	level_camera = _camera

func move_to_first():
	ending_id = MPlayerManager.get_target_id()
	MPlayerManager.emit_signal("reach_target", first_point_shuttle, ending_id)
	#MPlayerManager.emit_signal("set_invulnerability",ending_duration+move_to_duration+60)
	#MPlayerManager.emit_signal("player_following", true)
	#$Tween.interpolate_property(shuttle, position, shuttle.position, first_point_shuttle, move_to_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	#$Tween.interpolate_callback(self, move_to_duration, "start_ending")
	#$Tween.start()
	
func start_ending(_id):
	if _id == ending_id:
		$CameraPath/Follow/Camera2D.current = true
		level_camera.current = false
		shuttle.set_follow_duration($CameraPath.curve, ending_duration)
		$Tween.interpolate_property($CameraPath/Follow,"unit_offset", 0, 1, ending_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()

func _on_VisibilityNotifier2D_screen_entered():
	if !trigger:
		trigger = true
		shuttle.approach_the_end()
		#move_to_first()
	pass # Replace with function body.
