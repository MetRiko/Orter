extends KinematicBody2D

var health = 0

func setHealth(value):
	health = value
	if health <= 0:
		queue_free()
	$Sprite.frame = clamp(health - 1, 0, 3)
	
func subHealth(value):
	setHealth(health - value)
	
func _ready():
	setHealth(4)