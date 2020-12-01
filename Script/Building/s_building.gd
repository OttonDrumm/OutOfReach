extends Node2D

var progress = 0

func _ready():
	$Ready/Progress.value = MProgressManager.get_progress()
	$Ready/Progress.max_value = MProgressManager.get_max_progress()
	if $Ready/Progress.value >= $Ready/Progress.max_value:
		$Ready/TextureButton.modulate.a = 1
		$Ready/TextureButton.disabled = false
	else:
		$Ready/TextureButton.modulate.a = 0
		$Ready/TextureButton.disabled = true
	MPlayerManager.connect("chapter_changed", self, "_on_chapter_change")
	MProgressManager.connect("progress_changed", self, "update_progress")
	$Tween.interpolate_property($Audio, "volume_db", MAudioManager.muted_volume, MAudioManager.volume, 2,Tween.TRANS_LINEAR,Tween.EASE_IN, 1)
	$Tween.start()
	$Audio.play()

func _on_chapter_change():
	pass

func _on_BuildInterface_create_piece(_piece):
	$EnginePaper.add_piece(_piece)

func enable():
	$Ready/Label.text = "GO!"
	$Ready/TextureButton.disabled = false

func update_progress():
	$Ready/Tween.stop($Ready/Progress)
	$Ready/Tween.interpolate_property($Ready/Progress, "value", $Ready/Progress.value, MProgressManager.get_progress(), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Ready/Progress.max_value = MProgressManager.get_max_progress()
	if $Ready/TextureButton.disabled and MProgressManager.get_progress() >= MProgressManager.get_max_progress():
		$Ready/Tween.interpolate_property($Ready/TextureButton, "modulate:a", 0, 1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.5)
		$Ready/Tween.interpolate_callback(self, 1, "enable")
	$Ready/Tween.start()
	


func _on_TextureButton_pressed():
	MSceneLoader.load_current_launch()
