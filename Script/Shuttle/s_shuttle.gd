extends Node2D

signal move
signal die

const piece_type = preload("res://Script/s_piece.gd")
const engine_scene = preload("res://Scenes/Shuttle/Engine.tscn")
const engine_prefix = "Engine_"

onready var body = $Path/Follow/Pieces
onready var rotating_body = $Path/Follow/Pieces/Rotating
onready var camera = $Path/Follow/Pieces/Camera2D2
var shield = 0
var boost = 1
var fuel = 0
var max_fuel = 0
var speed = Vector2.ZERO
var fall_speed = 40
var decay = {
	"enabled": {
		"x": false,
		"y": false
	},
	"intensity": Vector2(0.1, 0.1)
}
var status = {
	"forward": false,
	"falling": false,
	"turning": false,
	"boosting": false
}
var dead = false
var using_engine = 1
export var forced_scale = Vector2(0.7,0.7)
onready var turn_input = {
	"left": {
		"direction": -1,
		"tween": $TweenLeft
	},
	"right": {
		"direction": 1,
		"tween": $TweenRight
	}
}
var target_position = null
var target_id = null
var antigravity = false

# Called when the node enters the scene tree for the first time.
func _ready():
	body.get_node("Rotating").scale = forced_scale
	MPlayerManager.emit_signal("update_position", body.position)
	MPlayerManager.connect("kill_player", self, "die")
	MPlayerManager.connect("send_damage", self, "receive_damage")
	shield = MStatManager.stats.shield[MPieceManager.current_engine]
	fuel = MStatManager.stats.fuel[MPieceManager.current_engine]
	max_fuel = fuel

func build_engines():
	using_engine = MPlayerManager.chapter
	for e in MPieceManager.engines:
		var engine_name = engine_prefix + str(e)
		var engine = rotating_body.get_node_or_null(engine_name)
		if engine:
			engine.clear()
		else:
			engine = engine_scene.instance()
			engine.name = engine_name
			engine.chapter = e
			engine.scale = forced_scale
			rotating_body.add_child(engine)
			engine.connect("collision_detected", self, "_collision_detected")
		engine.build(rotating_body.get_node("Head").position)

func die():
	dead = true
	$Tween.stop_all()
	$TweenLeft.stop_all()
	$TweenRight.stop_all()
	emit_signal("die")

func _collision_detected(_id, _layer):
	if _layer == MPlayerManager.death_layer:
		MPlayerManager.emit_signal("kill_player")
	elif _layer == MPlayerManager.sight_layer:
		print("see")
	elif _layer == MPlayerManager.damage_layer:
		print("ouch")

func move_forward():
	$Tween.stop(self,"speed:y")
	if status.forward and MStatManager.stats.speed[using_engine] > 0:
		$Tween.interpolate_property(self, "speed:y", speed.y, -MStatManager.stats.speed[using_engine], 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	elif !antigravity:
		$Tween.interpolate_property(self, "speed:y", speed.y, fall_speed, 5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	#if speed.y >= -MStatManager.max_stats[using_engine].speed:
	#	speed.y -= MStatManager.stats.speed[using_engine]

func turn_left():
	turn(-1)
	
func turn_right():
	turn(1)

func turn(_turn_input):
	var tween = _turn_input.tween
	tween.stop_all()
	if $Path.curve:
		return
	if status.turning:
		var _direction = _turn_input.direction
		tween.interpolate_property(self, 
		"speed:x", 
		speed.x, 
		_direction*MStatManager.stats.manovrability[using_engine],
		1,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.interpolate_property(rotating_body, 
		"rotation_degrees", 
		rotation_degrees, 
		_direction*30,
		1,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()

func _input(event):
	if !dead and event is InputEventKey and !event.is_echo():
		if MCommandManager.key_input.up.has(event.get_scancode()):
			status.forward = event.is_pressed()
			move_forward()
		elif MCommandManager.key_input.left.has(event.get_scancode()):
			status.turning = event.is_pressed()
			turn(turn_input.left)
		elif MCommandManager.key_input.right.has(event.get_scancode()):
			status.turning = event.is_pressed()
			turn(turn_input.right)
		elif MCommandManager.key_input.boost.has(event.get_scancode()):
			boost(event.is_pressed())

func boost(_value):
	status.boosting = _value
	if _value:
		boost = 2
	else:
		boost = 1

func update_fuel(_value):
	if status.boosting and fuel <= 0:
		boost(false)
		return
	elif status.boosting:
		fuel -= _value
	elif fuel < max_fuel:
		fuel += _value/3
	MPlayerManager.emit_signal("update_fuel", fuel)

func _process(delta):
	if !$Path.curve and !dead:
		update_fuel(delta)
		if (speed.y <= 0):
			body.position+=speed*boost
		else:
			body.position.x+=speed.x*boost
			body.position.y+=speed.y/boost
		#MPlayerManager.emit_signal("update_position", $Pieces.position)
		MPlayerManager.emit_signal("update_camera_position", camera.get_camera_screen_center())
		#if speed.y < 0:
		#	$FollowVertical.position.y += speed.y

func receive_damage(_damage):
	shield -= _damage
	return
	if (shield < 0):
		MPlayerManager.emit_signal("kill_player")
	else:
		$AudioImpact.play()
		$AnimationPlayer.play("DamageBlink", -1, 2/(MPlayerManager.damage_boost_time/1000))

func set_follow(_follow_path, mn, mx):
	if _follow_path is Curve2D:
		$Path.curve = _follow_path
		body.rotation_degrees = 90
		$Tween.stop_all()
		speed.y = max(min(MStatManager.stats.speed[using_engine],mx),mn)
		var duration = _follow_path.get_baked_length()/speed.y/70
		$Tween.interpolate_property($Path/Follow, "unit_offset", 0, 1, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.interpolate_callback(self, duration, "remove_path")
		MPlayerManager.emit_signal("player_following", true)
		MPlayerManager.emit_signal("set_invulnerability",duration)
		$Tween.start()
		status.forward = true
		move_forward()

func set_follow_duration(_follow_path, _duration):
	if _follow_path is Curve2D:
		$Path.curve = _follow_path
		body.rotation_degrees = 90
		$Tween.stop_all()
		$Tween.interpolate_property($Path/Follow, "unit_offset", 0, 1, _duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.interpolate_callback(self, _duration, "remove_path")
		MPlayerManager.emit_signal("player_following", true)
		MPlayerManager.emit_signal("set_invulnerability",_duration)
		$Tween.start()
		status.forward = true
		move_forward()
	

func remove_path():
	MPlayerManager.emit_signal("player_following", false)
	$Path.curve = null
	$Path/Follow.rotation_degrees = 0
	body.rotation_degrees = 0

func move_to(_position, _id):
	target_position = _position
	target_id = _id
	
func approach_the_end():
	MPlayerManager.emit_signal("set_invulnerability",60)
	antigravity = true
	MSceneLoader.load_finale(10)
