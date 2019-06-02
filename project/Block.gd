extends KinematicBody2D

const MOVEMENT = 192

var motion = Vector2()

var time = 0
var time_mult = 1.0
var time_paused = false

func _ready():
	add_to_group("blocks")

func _physics_process(delta):
	
	motion.x = 0
	
	time += delta * time_mult
	
	if (time >= 0.5 && not time_paused):
		motion.y = MOVEMENT
		move_and_collide(motion)
		time = 0
	else:
		motion.x = 0
		motion.y = 0
		move_and_collide(motion)
	
	if is_on_floor():
		motion.x = 0
		motion.y = 0
		time_paused = true
	
	pass