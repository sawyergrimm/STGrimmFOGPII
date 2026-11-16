extends Button

func _on_button_down() -> void:
	get_tree().paused = false
	get_parent().set_process(false)
	pass # Replace with function body.
