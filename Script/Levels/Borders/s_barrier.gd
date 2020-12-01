extends Area2D

export var duration = 60
var h
export var sprite_start = 1
export var sprite_count = 4
export var d = [0, 1, -1, 1, -1]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.repeat = true
	h = $Sprite1.get_rect().size.y/4
	for i in range(sprite_start, sprite_count+1):
		interpolate(get_node_or_null("Sprite"+str(i)), d[i])
	$Tween.start()
	pass # Replace with function body.

func interpolate(_object, _direction = 1):
	if (_object):
		$Tween.interpolate_property(_object, "position:y", -1*_direction*(h-1), _direction*(h+1),duration,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
