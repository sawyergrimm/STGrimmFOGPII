extends CanvasLayer

@onready var healthCounter = $Control/HealthUI/Label
@onready var bulletCounter = $Control/BulletUI/Label


func _ready() -> void:
	healthCounter.set_text("")
	bulletCounter.set_text("")



func set_health(health: int) -> void:
	healthCounter.set_text("Health:"+str(health))

func set_bullets(bullets: int) ->void:
	bulletCounter.set_text("Ammo:" + str(bullets))
