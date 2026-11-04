extends StaticBody2D

func Death() -> void:
	var deathTween = get_tree().create_tween()
	deathTween.tween_property(self, 'scale', Vector2(0, 0), 0.1)
	deathTween.tween_callback(queue_free)
