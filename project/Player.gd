extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 40
const SPEED_GAIN = 70
const MAX_SPEED = 400
const JUMP_HEIGHT = -1200

var motion = Vector2()

onready var Block = preload("res://BlockSet.tscn")

func _ready():
	yield(get_tree(), "idle_frame")
	get_tree().call_group("blocks","set_player", self)

func _physics_process(delta):
	
	motion.y += GRAVITY
	
	if Input.is_action_pressed("ui_right"):
		if (motion.x<MAX_SPEED && motion.x>-MAX_SPEED):
			motion.x += SPEED_GAIN
	elif Input.is_action_pressed("ui_left"):
		if (motion.x<MAX_SPEED && motion.x>-MAX_SPEED):
			motion.x += -SPEED_GAIN
	else:
		motion.x = 0
	
	if Input.is_action_just_released("ui_right"):
		motion.x = 0
	
	if Input.is_action_just_released("ui_left"):
		motion.x = 0
	
	if is_on_floor():
		
		if Input.is_action_pressed("ui_up"):	#skok
			motion.y = JUMP_HEIGHT
	
	motion = move_and_slide(motion, UP)#ruch wraz ze skokiem i zerowaniem prędkości
	
	pass