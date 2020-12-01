extends Control

var is_death = false
export var is_build = false

# Called when the node enters the scene tree for the first time.
func _ready():
	unpause()
	if is_build:
		$Retry.hide()
		$Build.hide()
	MPlayerManager.connect("kill_player", self, "death_menu")

func _input(event):
	if !is_death and event is InputEventKey and event.is_pressed() and !event.is_echo() and MCommandManager.key_input.pause.has(event.get_scancode()):
		if !get_tree().paused:
			pause()
		else:
			unpause()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func death_menu():
	pause(true)

func pause(on_death = false):
	is_death = on_death
	get_tree().paused = true
	if !is_build:
		$Retry/Button.disabled = false
		$Build/Button.disabled = false
	if is_death and !is_build:
		$Resume/Button.disabled = true
	else:
		$Resume/Button.disabled = false
	$Quit/Button.disabled = false
	show()

func unpause(_transition = false):
	if _transition:
		$Tween.interpolate_callback(self, MSceneLoader.transition_time, "unpause", false)
	else:
		is_death = false
		get_tree().paused = false
		$Retry/Button.disabled = true
		$Build/Button.disabled = true
		$Resume/Button.disabled = true
		$Quit/Button.disabled = true
		hide()
	
func _on_Quit_pressed():
	MSceneLoader.load_main_menu()
	unpause(true)


func _on_Build_pressed():
	MSceneLoader.load_building_scene()
	unpause(true)


func _on_Retry_pressed():
	MSceneLoader.load_current_launch()
	unpause(true)
