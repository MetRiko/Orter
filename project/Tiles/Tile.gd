extends StaticBody2D

export var maxHealth = 100.0
onready var currentHealth = maxHealth

func damage(amount):
	currentHealth -= amount
	if currentHealth <= 0:
		queue_free()
