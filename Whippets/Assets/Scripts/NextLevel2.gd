extends Area2D






func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_file("res://Assets/Scenes/Level3.tscn")
	pass # Replace with function body.
