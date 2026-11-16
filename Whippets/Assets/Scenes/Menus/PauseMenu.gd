extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		if visible == true:
			visible = false
			get_tree().paused = false
		else:
			visible = true
			get_tree().paused = true
	pass


func _on_play_button_down() -> void:
	visible = false
	get_tree().paused = false
	pass # Replace with function body.


func _on_quit_button_down() -> void:
	get_tree().quit()
	pass # Replace with function body.
