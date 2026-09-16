extends CharacterBody2D

@export var bullet : PackedScene
@export var box : PackedScene
@export var gun : PackedScene
const SPEED = 100.0
const JUMP_VELOCITY = -200.0

var gunarm = load("res://Assets/Sprites/Player/gunarm.png")
var arm = load("res://Assets/Sprites/Player/arm.png")
var whippet = load("res://Assets/Sprites/Player/whippet.png")
var whippetSmoke = load("res://Assets/Particles/WhippetSmoke.tscn")
var greyscale = load("res://Assets/Colors/grayscaleFade.tres")
var redscale = load("res://Assets/Colors/redscaleFade.tres")
var healthUI
var bulletUI
var blindness

var counter = 10
var whippetCounter = -1
var bulletInstanceCounter = 0
var ammo = 10
var whippets = 100
var hasGun = true
var health = 3

func _ready() -> void:
	add_to_group("player")
	healthUI = get_tree().current_scene.find_child("HealthUI")
	bulletUI = get_tree().current_scene.find_child("BulletUI")
	blindness = $Blindness

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
			$GunCatchPlayer.play()
			
			$Gunarm.texture = gunarm
		
	
	pass

func _process(_delta: float) -> void:
	if health <= 0:
		get_tree().change_scene_to_file("res://Assets/Scenes/shot_scene.tscn")
	if Input.is_action_just_pressed("LeftMouseClick"):
		if hasGun and ammo > 0 and $Gunarm.texture == gunarm:
			ammo -= 1
			$GunShotPlayer.play()
			var b = bullet.instantiate()
			b.player = self
			b.firer = self.name
			b.name = "bullet" + str(bulletInstanceCounter)
			bulletInstanceCounter += 1
			b.velocity = $Gunarm.transform.x * 200
			get_tree().current_scene.add_child(b)
			if $Gunarm.transform.get_rotation() > PI/2 or $Gunarm.transform.get_rotation() < -PI/2:
				b.global_transform = $Gunarm/MarkerLeft.global_transform
			else:
				b.global_transform = $Gunarm/MarkerRight.global_transform
		
		elif $Gunarm.texture == whippet:
			whippetCounter += 1
			if whippetCounter > 0:
				blindness.amount = whippetCounter * 100
				blindness.scale_amount_max = 8 * whippetCounter
				if blindness.scale_amount_max > 100:
					blindness.scale_amount_max = 100
				blindness.scale_amount_min = 4 * whippetCounter
				if blindness.scale_amount_min > 50:
					blindness.scale_amount_min = 50
				blindness.lifetime = whippetCounter * whippetCounter / (0.2 * whippetCounter)
				if blindness.lifetime > 50:
					blindness.lifetime = 50
				blindness.emitting = true
			if whippetCounter > 6:
				blindness.color = Color.DARK_RED
				blindness.color_ramp = redscale
			if whippetCounter >= 9:
				get_tree().change_scene_to_file("res://Assets/Scenes/overdoseScene.tscn")
				return
				
			
			var particle = whippetSmoke.instantiate()
			health = 3
			whippets -= 1
			$WhippetPlayer.play()
			if whippets == 0:
				if hasGun:
					$Gunarm.texture = gunarm
				else:
					$Gunarm.texture = arm
			get_tree().current_scene.add_child(particle)
			particle.global_position = $Gunarm/MarkerLeft.global_position
			particle.emitting = true
			particle.finished.connect(particle.queue_free)

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
		g.linear_velocity = $Gunarm.transform.x * 100 + Vector2(velocity.x / 3, 0)
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
	
	if Input.is_action_just_pressed("Shift"):
		if $Gunarm.texture == whippet and hasGun:
			$Gunarm.texture = gunarm
		elif $Gunarm.texture == whippet:
			$Gunarm.texture = arm
		elif whippets > 0:
			$Gunarm.texture = whippet
	healthUI.get_child(0).set_text("Health:"+str(health))
	bulletUI.get_child(0).set_text("Ammo:" + str(ammo))
	
	pass
