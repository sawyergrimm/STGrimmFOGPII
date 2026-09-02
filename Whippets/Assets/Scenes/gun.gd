extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _physics_process(delta: float) -> void:
	var collisions := move_and_collide(linear_velocity * delta)
	if collisions:
		var body = collisions.get_collider()
		if body.name.contains("enemy") and get_tree().current_scene.find_child("Player").ammo < 10:
			$AudioStreamPlayer2D.play()
			get_tree().current_scene.find_child("Player").ammo = 10
			$AnimatedSprite2D.play("shiny")


	pass


func _process(_delta: float) -> void:
	
	pass
