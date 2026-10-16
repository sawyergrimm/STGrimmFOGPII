extends RigidBody2D

@export var bloodSplatter : PackedScene
@export var bullet : PackedScene


var ammo = 10
var bulletInstanceCounter = 0
var timeVar = 0.0
var interval = 1.0
var health = 3
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 10
	player = get_tree().current_scene.find_child("Player")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health <= 0:
		queue_free()
	timeVar += delta
	var _collisions = get_colliding_bodies()	
	if timeVar > interval:
		timeVar -= interval
		if position.distance_to(player.position) < 130:
			ammo -= 1
			$GunShotEnemy.play()
			var b = bullet.instantiate()
			b.player = self
			b.name = "bullet" + str(bulletInstanceCounter)
			bulletInstanceCounter += 1
			b.velocity = $Gunarm.transform.x * 200
			get_tree().current_scene.add_child(b)
			if $Gunarm.transform.get_rotation() > PI/2 or $Gunarm.transform.get_rotation() < -PI/2:
				b.global_transform = $Gunarm/MarkerLeft.global_transform
			else:
				b.global_transform = $Gunarm/MarkerRight.global_transform
	pass
