extends StaticBody2D

func Death() -> void:
	var deathTween = get_tree().create_tween()
	deathTween.tween_property(self, 'position', Vector2(0, 60), 0.7).as_relative()
	deathTween.tween_callback(queue_free)
