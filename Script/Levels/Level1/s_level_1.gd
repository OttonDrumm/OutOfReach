extends Node2D

onready var shuttle = $Shuttle

func _ready():
	#MPlayerManager.connect("update_position", self, "follow_player")
	MPlayerManager.connect("update_camera_position", self, "follow_camera")
	MPlayerManager.connect("send_damage", self, "update_shield")
	MPlayerManager.connect("update_fuel", self, "update_fuel")
	shuttle.build_engines()
	$FollowCamera/Shield.max_value = MStatManager.get_max_stat(MPieceManager.current_engine, 'shield')
	$FollowCamera/Shield.value = MStatManager.stats.shield[MPieceManager.current_engine]
	$FollowCamera/Fuel.max_value = MStatManager.get_max_stat(MPieceManager.current_engine, 'fuel')
	$FollowCamera/Fuel.value = MStatManager.stats.fuel[MPieceManager.current_engine]
	shuttle.set_follow($Paths/StartingPath.curve, 4, 7)
	$Ending1.set_shuttle(shuttle)

func follow_camera(_camera_center):
	$FollowCamera.position = _camera_center

func follow_player(_player_position):
	$FollowBackground.position.x = _player_position.x
	$FollowForeground.position.x = _player_position.x
	if _player_position.y <= $FollowBackground.position.y:
		$FollowBackground.position.y = _player_position.y
	if _player_position.y <= $FollowForeground.position.y:
		$FollowForeground.position.y = _player_position.y

func update_shield(_damage):
	$FollowCamera/Shield.value -= _damage
	
func update_fuel(_fuel):
	#$Tween.interpolate_property($FollowCamera/Fuel, "value", $FollowCamera/Fuel.value, _fuel, 0.1, )
	$FollowCamera/Fuel.value = _fuel
