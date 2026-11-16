extends Sprite2D

var gunarm = load("res://Assets/Sprites/Enemy/enemyGunarm.png")
var player
var enemy
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().current_scene.find_child("Player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if enemy.canSeePlayer:
		look_at(player.position)
	if transform.get_rotation() > PI/2 or transform.get_rotation() < -PI/2:
		flip_v = 1
	else:
		flip_v = 0
	
	pass
