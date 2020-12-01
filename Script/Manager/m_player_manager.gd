extends Node

signal chapter_changed
signal update_position
signal update_camera_position
signal update_fuel
signal kill_player
signal inflict_damage
signal send_damage
signal set_invulnerability
signal player_following

signal reach_target
signal target_reached
var target_id = 0

var damage_boost_time = 2000
var chapter = 1
const damage_layer = 8
const death_layer = 16
const sight_layer = 32

var player_pos
var last_damage = 0

func _ready():
	connect("update_position",self,"update_player_position")
	connect("inflict_damage",self,"handle_damage")
	pass # Replace with function body.

func go_to_next_chapter():
	if chapter < 3:
		chapter += 1
	emit_signal("chapter_changed")
	
func go_to_prev_chapter():
	if chapter > 1:
		chapter -= 1
	emit_signal("chapter_changed")

func update_player_position(_player_position):
	player_pos = _player_position
	
func handle_damage(_damage):
	var time = OS.get_ticks_msec()
	if time >= last_damage + damage_boost_time:
		last_damage = time
		emit_signal("send_damage", _damage)

func get_target_id():
	target_id += 1
	return target_id
	
