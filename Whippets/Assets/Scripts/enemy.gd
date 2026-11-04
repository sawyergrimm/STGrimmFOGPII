extends RigidBody2D

@export var bloodSplatter : PackedScene
@export var bullet : PackedScene


var ammo = 10
var bulletInstanceCounter = 0
var timeVar = 0.0
var interval = 1.0
var health = 1
var player
var killed = false

#Movement-related variables
var targetDestination: float #The x-value that is the pathfinding target
var direction = 1
var lastX: float
var jumpPatience = 5
var swapPatience = 90
var jumpPatienceCounter = 0
var swapPatienceCounter = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 10
	player = get_tree().current_scene.find_child("Player")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health <= 0 and killed == false:
		killed = true
		Death()
	timeVar += delta
	if timeVar > interval:
		timeVar -= interval
		Shoot()
	pass


func _physics_process(delta: float) -> void:
	Move(delta)
	if Input.is_action_just_released("EnemyJump"):
		linear_velocity.y = -250
	pass
	
func Move(delta: float) -> void:
	if global_position.x == lastX and global_position.x == lastX :
		jumpPatienceCounter += 1
		swapPatienceCounter += 1
	if jumpPatienceCounter > jumpPatience:
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(0, 10))
		var result = space_state.intersect_ray(query)
		if !result.is_empty():
			linear_velocity.y = -250
		jumpPatienceCounter = 0
		jumpPatience = randi_range(5,50)
	if swapPatienceCounter > swapPatience:
		SelectTargetDestination()
		swapPatienceCounter = 0

	if (direction == 1 and global_position.x > targetDestination) or (direction == -1 and global_position.x < targetDestination):
		SelectTargetDestination()
	linear_velocity += Vector2(direction * 150 * delta, 0)
	lastX = global_position.x
	pass

func SelectTargetDestination() -> void:
	targetDestination = global_position.x + ( (randf() - 0.5) * 150);
	if targetDestination < global_position.x:
		direction = -1
	else:
		direction = 1

func Shoot() -> void:
	if position.distance_to(player.position) < 130 and !killed:
		ammo -= 1
		$GunShotEnemy.play()
		var b = bullet.instantiate()
		b.player = self
		b.name = "bullet" + str(bulletInstanceCounter)
		bulletInstanceCounter += 1
		b.velocity = ($Gunarm.transform.x + Vector2(0, randf_range(-0.1,0.1))) * 200
		get_tree().current_scene.add_child(b)
		if $Gunarm.transform.get_rotation() > PI/2 or $Gunarm.transform.get_rotation() < -PI/2:
			b.global_transform = $Gunarm/MarkerLeft.global_transform
		else:
			b.global_transform = $Gunarm/MarkerRight.global_transform


func Death() -> void:
	$CollisionShape2D.queue_free()
	$DeathPlayer.play()
	var deathTween = get_tree().create_tween()
	deathTween.tween_property(self, 'scale', Vector2(0, 0), 0.1)
	$AnimatedSprite2D.queue_free()
	deathTween.tween_property(self, 'scale', Vector2(0, 0), 0.5)
	deathTween.tween_callback(queue_free)
