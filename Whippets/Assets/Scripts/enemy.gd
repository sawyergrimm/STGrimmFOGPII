extends RigidBody2D

@export var bloodSplatter : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 10
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var collisions = get_colliding_bodies()
	for collision in collisions:
		if collision.name.contains("bullet"):
			var particle = bloodSplatter.instantiate()
			get_tree().current_scene.add_child(particle)
			particle.global_transform = collision.global_transform
			particle.emitting = true
			particle.get_child(0).finished.connect(particle.queue_free)
	pass
