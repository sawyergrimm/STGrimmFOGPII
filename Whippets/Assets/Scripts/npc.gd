extends Area2D

var wall
var ceiling

var interactable = false
var interactCount = 0
var textArray = ["Yo!", "Press shift to swap to your nitrous can!", "Left click to use that to heal", "But don't use it too much! Shift again to swap back.", "Right click to throw your gun!", "If you hit an enemy with your gun...", "You reload!", "Good luck!", ""]

func _ready():
	wall = get_tree().current_scene.find_child("RemovableWall")
	ceiling = get_tree().current_scene.find_child("RemovableCeiling")
	$TutorialText.visible = false

func _on_body_entered(body):
	if body.name == "Player":
		$TutorialText.visible = true
		interactable = true
	pass

func _physics_process(_delta: float) -> void:
	$TutorialText.text = textArray[interactCount]
	if interactCount == 0 and Input.is_action_just_pressed("Interact"):
		$TutorialText/Label.visible = false
		$Chatter.play()
		interactCount += 1
	if interactCount == 1 and Input.is_action_just_pressed("Shift"):
		$Chatter.play()
		interactCount += 1
	if interactCount == 2 and Input.is_action_just_pressed("LeftMouseClick"):
		$Chatter.play()
		interactCount += 1
	if interactCount == 3 and Input.is_action_just_pressed("Shift"):
		$Chatter.play()
		interactCount += 1
	if interactCount == 4 and Input.is_action_just_pressed("RightMouseClick"):
		$Chatter.play()
		interactCount += 1
		$TutorialText/Label.visible = true
	if interactCount == 5 and Input.is_action_just_pressed("Interact"):
		$Chatter.play()
		interactCount += 1
		await get_tree().create_timer(0.2).timeout
	if interactCount == 6 and Input.is_action_just_pressed("Interact"):
		$Chatter.play()
		interactCount += 1
	if interactCount == 7 and Input.is_action_just_pressed("Interact"):
		$Chatter.play()
		interactCount += 1
	if interactCount == 8:
		wall.Death()
		ceiling.Death()
		Death()
		
func Death() -> void:
	var deathTween = get_tree().create_tween()
	deathTween.tween_property(self, 'scale', Vector2(0, 0), 0.1)
	deathTween.tween_callback(queue_free)
