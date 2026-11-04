extends Node2D

func Open() -> void:
	var deathTween = get_tree().create_tween()
	deathTween.tween_property(self, 'position', Vector2(0,50), 1.0).as_relative()
