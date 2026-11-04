extends Node2D

var door

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	door = get_node("/root/Node2D/Door")
	pass # Replace with function body.


func Shot() -> void:
	door.Open()
	Death()
	

func Death() -> void:
	var deathTween = get_tree().create_tween()
	deathTween.tween_property(self, 'scale', Vector2(0,0), 0.3)
	deathTween.tween_callback(queue_free)
