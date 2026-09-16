extends Area2D

var interactable = false
var interactCount = 0
var textArray = ["Yo!", "Press shift to swap to your nitrous can!", "Left click to use that to heal", "But don't use it too much!", "Right click to throw your gun!", "If you hit an enemy with your gun...", "You reload!", "Good luck!", ""]
func _ready():
	$TutorialText.visible = false

func _on_body_entered(body):
	if body.name == "Player":
		$TutorialText.visible = true
		interactable = true
	pass

func _physics_process(delta: float) -> void:
	$TutorialText.text = textArray[interactCount]
	if Input.is_action_just_pressed("Interact"):
		$TutorialText/Label.visible = false
		interactCount += 1
	if interactCount == 8:
		
		queue_free()
