extends Node2D

var is_active = false
const duration = 0.3
var target_alpha = 0.5
var target_engine = null
var is_following = false

# Called when the node enters the scene tree for the first time.
func _ready():
	MPlayerManager.connect("player_following", self, "set_follow")
	pass # Replace with function body.

func set_engine(_engine):
	target_engine = get_node_or_null("Fire_"+str(_engine))
	$Fire_1.modulate.a = 0
	$Fire_2.modulate.a = 0
	$Fire_3.modulate.a = 0
	$Fire_1.hide()
	$Fire_2.hide()
	$Fire_3.hide()
	if (target_engine):
		target_engine.show()

func set_active(_value):
	if !is_active and _value:
		$AudioStart.play()
		target_engine.play()
		change_visibility(true)
	if is_active and !_value:
		$AudioStart.stop()
		$AudioOngoing.stop()
		change_visibility(false)
	is_active = _value
	pass

func change_visibility(_visible):
	if _visible:
		$Tween.interpolate_property(target_engine, "modulate:a", target_engine.modulate.a, 1,duration,Tween.TRANS_LINEAR,Tween.EASE_IN)
		$Tween.start()
	else:
		$Tween.interpolate_property(target_engine, "modulate:a", target_engine.modulate.a, 0,duration,Tween.TRANS_LINEAR,Tween.EASE_IN)
		$Tween.start()

func _input(event):
	if !target_engine:
		return
	if event is InputEventKey and MCommandManager.key_input.up.has(event.get_scancode()):
		set_active(event.is_pressed() or is_following)

func set_follow(_value):
	is_following = _value
	set_active(_value)

func _on_Tween_tween_all_completed():
	if target_engine.modulate.a == 0:
		target_engine.stop()


func _on_AudioStart_finished():
	if is_active:
		$AudioOngoing.play()
	pass # Replace with function body.
