extends Sprite2D

var gunarm = load("res://Assets/Sprites/Player/gunarm.png")
var arm = load("res://Assets/Sprites/Player/arm.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	if transform.get_rotation() > PI/2 or transform.get_rotation() < -PI/2:
		flip_v = 1
	else:
		flip_v = 0
	
	pass
