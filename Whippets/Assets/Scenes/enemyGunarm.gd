extends Sprite2D

var gunarm = load("res://Assets/Sprites/Enemy/enemyGunarm.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	look_at(player.position)
	if transform.get_rotation() > PI/2 or transform.get_rotation() < -PI/2:
		flip_v = 1
	else:
		flip_v = 0
	
	pass
