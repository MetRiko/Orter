extends KinematicBody2D

const MOVEMENT = 192

var motion = Vector2()

var time = 0
#var timeSidestep = 0
#var timeRotation = 0
var timeMult = 1.0
var timePaused = false
#var randSide = null
#var randRot = null

func _ready():
	add_to_group("blocks")

func _physics_process(delta):
	
	motion.x = 0
	
	time += delta * timeMult
#	timeSidestep += delta * timeMult
#	timeRotation += delta * timeMult
	
#	if (timeSidestep >= 2 and not timePaused):
#		randSide = randi()%8+1
#		if (randSide==1):
#			motion.x = MOVEMENT
#		elif (randSide==2):
#			motion.x = -MOVEMENT
#		else:
#			motion.x = 0
#		move_and_collide(motion)
#		motion.x = 0
#		timeSidestep = 0
	
#	if (timeRotation >= 3 and not timePaused):
#		randRot = randi()%10+1
#		if (randRot==1):
#			rotation_degrees += 90
#		elif (randRot==2):
#			rotation_degrees -= 90
#		else:
#			rotation = rotation
#		move_and_collide(motion)
#		timeRotation = 0
	
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