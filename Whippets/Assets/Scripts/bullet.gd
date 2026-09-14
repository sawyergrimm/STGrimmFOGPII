extends RigidBody2D

const bulletImpact = preload("res://Assets/Particles/BulletImpact.tscn")
const boxBreak = preload("res://Assets/Particles/BoxBreak.tscn")
const bloodSplatter = preload("res://Assets/Particles/bloodsplatter.tscn")
@export var player: Node2D
var velocity: Vector2
var firer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var collisionInfo := move_and_collide(velocity * delta)
	if collisionInfo:
		var body = collisionInfo.get_collider()
		
		#What to do on contact with player
		if body.name == "Player":
			body.health -= 1
			var particle = bloodSplatter.instantiate()
			get_tree().current_scene.add_child(particle)
			particle.global_transform = global_transform
			particle.emitting = true
			particle.finished.connect(particle.queue_free)	
			
		#Generic rigidbody collision
		elif body is RigidBody2D:
			var forceDir = (body.global_position - global_position).normalized()
			body.apply_central_impulse(forceDir * 10)
			if firer == body.name: pass
			if body.name.contains("enemy"):
				body.health -= 1
				var particle = bloodSplatter.instantiate()
				get_tree().current_scene.add_child(particle)
				particle.global_transform = global_transform
				particle.emitting = true
				particle.finished.connect(particle.queue_free)
			if body.name.contains("box"):
				body.health -= 1
				var boxbreak = boxBreak.instantiate()
				get_tree().current_scene.add_child(boxbreak)
				boxbreak.global_transform = body.global_transform
				boxbreak.get_child(0).emitting = true
				boxbreak.get_child(0).finished.connect(boxbreak.queue_free)
		else:
			var particle = bulletImpact.instantiate()
			get_tree().current_scene.add_child(particle)
			particle.global_transform = global_transform
			particle.get_child(0).emitting = true
			particle.get_child(0).finished.connect(particle.queue_free)
		
		queue_free()
	if player and position.distance_to(player.position) > 1000:
		queue_free()
	pass
