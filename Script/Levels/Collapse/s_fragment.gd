extends RigidBody2D

const allowed_sizes = ["xs", "sm", "md", "lg"]
export(String, "xs", "sm", "md", "lg") var size = "xs"
var dim = {
	"xs": 4,
	"sm": 5,
	"md": 4,
	"lg": 4
}
var f_mass = {
	"xs": 1,
	"sm": 2,
	"md": 3,
	"lg": 4
}
var lifespan = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	pass # Replace with function body.

func _process(delta):
	lifespan -= delta
	if lifespan <= 0:
		queue_free()

func _generate(_size = null):
	var rng = RandomNumberGenerator.new()
	if (_size and _size in allowed_sizes):
		size = _size
	else:
		rng.randomize()
		size = allowed_sizes[rng.randi_range(0,allowed_sizes.size()-1)]
	rng.randomize()
	var n = size + "_" + str(rng.randi_range(1,dim[size]))
	for c in get_children():
		if n in c.name:
			c.show()
		else:
			remove_child(c)
	if get_child_count() == 0:
		queue_free()
	mass = f_mass[size]
	set_process(true)
