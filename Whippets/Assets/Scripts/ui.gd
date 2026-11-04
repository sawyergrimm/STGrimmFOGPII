extends CanvasLayer

@onready var healthCounter = $Control/HealthUI/Label
@onready var bulletCounter = $Control/BulletUI/Label


func _ready() -> void:
	healthCounter.set_text("")
	bulletCounter.set_text("")



func SetHealth(health: int) -> void:
	healthCounter.set_text("Health:"+str(health))

func SetBullets(bullets: int) ->void:
	bulletCounter.set_text("Ammo:" + str(bullets))
