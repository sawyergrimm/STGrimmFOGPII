extends CharacterBody2D

@export var bullet : PackedScene
@export var box : PackedScene
@export var gun : PackedScene
const SPEED = 100.0
const JUMP_VELOCITY = -200.0

var gunarm = load("res://Assets/Sprites/Player/gunarm.png")
var arm = load("res://Assets/Sprites/Player/arm.png")

var counter = 10
var bulletInstanceCounter = 0
var ammo = 10
var hasGun = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		$JumpGruntPlayer.play()
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if Input.get_axis("ui_left", "ui_right") != 0:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("default")
	if direction:
		velocity.x = direction * SPEED
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = 1
		elif velocity.x > 0:
			$AnimatedSprite2D.flip_h = 0
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, 12)
		else:
			velocity.x = move_toward(velocity.x, 0, 3)

	move_and_slide()
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		var body = collision.get_collider()
		if body != null and body.name.contains("gun"):
			body.free()
			hasGun = true
			$Gunarm.texture = gunarm
		
	
	pass

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("LeftMouseClick") and hasGun and ammo > 0:
		ammo -= 1
		$GunShotPlayer.play()
		var b = bullet.instantiate()
		b.player = self
		b.name = "bullet" + str(bulletInstanceCounter)
		bulletInstanceCounter += 1
		b.velocity = $Gunarm.transform.x * 1000
		get_tree().current_scene.add_child(b)
		if $Gunarm.transform.get_rotation() > PI/2 or $Gunarm.transform.get_rotation() < -PI/2:
			b.global_transform = $Gunarm/MarkerLeft.global_transform
		else:
			b.global_transform = $Gunarm/MarkerRight.global_transform
	
	if Input.is_action_just_pressed("RightMouseClick") and hasGun:
		$ThrowPlayer.play()
		hasGun = false
		$Gunarm.texture = arm
		var g = gun.instantiate()
		get_tree().current_scene.add_child(g)
		g.name = "gun"
		if $Gunarm.transform.get_rotation() > PI/2 or $Gunarm.transform.get_rotation() < -PI/2:
			g.global_transform = $Gunarm/MarkerLeft.global_transform
		else:
			g.global_transform = $Gunarm/MarkerRight.global_transform
		g.linear_velocity = $Gunarm.transform.x * 100
		if $AnimatedSprite2D.flip_h == true:
			g.angular_velocity = randi() % 50
		else:
			g.angular_velocity = randi() % 50 * -1
		
	if Input.is_action_just_pressed("SpawnBlock"):
		var boxy = box.instantiate()
		get_tree().current_scene.add_child(boxy)
		boxy.name = "box" + str(counter)
		counter += 1
		print_debug(boxy.name)
		boxy.transform = transform
		boxy.transform.y += Vector2(5,5)
	
	
	pass
