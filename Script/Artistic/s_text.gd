extends Label

export var moving = true
export var starting_size = 18
export var size_offset = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Tween.interpolate_property()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
