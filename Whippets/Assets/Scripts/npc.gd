extends Area2D

var wall

var interactable = false
var interactCount = 0
var textArray = ["Yo!", "Press shift to swap to your nitrous can!", "Left click to use that to heal", "But don't use it too much!", "Right click to throw your gun!", "If you hit an enemy with your gun...", "You reload!", "Good luck!", ""]

func _ready():
	wall = get_tree().current_scene.find_child("RemovableWall")
	$TutorialText.visible = false

func _on_body_entered(body):
	if body.name == "Player":
		$TutorialText.visible = true
		interactable = true
	pass

func _physics_process(_delta: float) -> void:
	$TutorialText.text = textArray[interactCount]
	if Input.is_action_just_pressed("Interact"):
		$TutorialText/Label.visible = false
		$Chatter.play()
		interactCount += 1
	if interactCount == 8:
		wall.queue_free()
		queue_free()
