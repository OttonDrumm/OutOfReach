extends Node2D

signal new_game

var journal_front = true

func _ready():
	$Journal_back.scale = Vector2(-1,1)
	$Journal_back.hide()
	$Journal_front.scale = Vector2(1,1)
	$Journal_front.show()
	journal_front = true
	$AnimationPlayerBack.play("MainMenuAnimation")
	$Audio.volume_db = MAudioManager.muted_volume
	$Tween.interpolate_property($Audio, "volume_db", MAudioManager.muted_volume, MAudioManager.volume, 2,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()
	$Audio.play()

func _on_Build_pressed():
	$Tween.interpolate_property($Audio, "volume_db", MAudioManager.volume, MAudioManager.muted_volume, 2,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()
	MSceneLoader.load_building_scene()

func flip_Journal():
	if journal_front:
		$AnimationPlayerFlip.play("FlipToBack")
	else:
		$AnimationPlayerFlip.play("FlipToFront")
	journal_front = !journal_front

func _on_Quit_pressed():
	get_tree().quit()
