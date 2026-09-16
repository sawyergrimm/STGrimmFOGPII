extends RigidBody2D

var player
var bloodSplatter = load("res://Assets/Particles/bloodsplatter.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().current_scene.find_child("Player")
	pass # Replace with function body.



func _physics_process(delta: float) -> void:
	var space_state = get_world_2d().direct_space_state
	var collisions := move_and_collide(linear_velocity * delta)
	if collisions:
		var body = collisions.get_collider()
			
		if !body.name.contains("Player"):
			var query = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(0, 5))
			var result = space_state.intersect_ray(query)
			print_debug(result)
			if result.is_empty(): linear_velocity = -1 * linear_velocity
		if body.name.contains("enemy"):
			var particle = bloodSplatter.instantiate()
			get_tree().current_scene.add_child(particle)
			particle.global_transform = global_transform
			particle.emitting = true
			particle.finished.connect(particle.queue_free)
			$AudioStreamPlayer2D.play()
			linear_velocity = -1 * linear_velocity
			body.health -= 1
			if player.ammo < 10: 
				player.ammo = 10
				$AnimatedSprite2D.play("shiny")
	pass


func _process(_delta: float) -> void:
	
	pass
