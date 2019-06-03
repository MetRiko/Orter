extends KinematicBody2D

const MOVEMENT = 192

var motion = Vector2()

var time = 0
var timeMult = 1.0
var timePaused = false

func _ready():
	add_to_group("blocks")

func _physics_process(delta):
	
	motion.x = 0
	
	time += delta * timeMult
	
	if (time >= 0.5 and not timePaused):
		motion.y = MOVEMENT
		move_and_collide(motion)
		time = 0
	else:
		motion.x = 0
		motion.y = 0
		move_and_collide(motion)

func _on_Area2D_area_entered(area):
	timePaused = true
	motion.x = 0
	motion.y = 0