extends Node2D

var dist = false

# Called when the node enters the scene tree for the first time.
func _ready():
	MPlayerManager.connect("update_position", self, "follow_player")
	$Shuttle.build_engines()
	$FollowVertical/Shield.max_value = MStatManager.get_max_stat(MPieceManager.current_engine, 'shield')
	$FollowVertical/Shield.value = MStatManager.stats.shield[MPieceManager.current_engine]

func _process(delta):
	$StrictFollow.global_position.y = $Shuttle/Pieces.global_position.y

func follow_player(_player_position):
	if _player_position.y < $FollowVertical.position.y:
		$FollowVertical.position.y = _player_position.y

