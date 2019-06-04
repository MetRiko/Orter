extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 60
const SPEED_GAIN = 100
const MAX_SPEED = 1400
const JUMP_HEIGHT = -1800

var motion = Vector2()

onready var Block = preload("res://BlockSet.tscn")
onready var BlockSet = get_tree().get_root().get_node("World").get_node("BlockSet")
onready var raycast = $RayCast2D
onready var raycast_down = $RayCast2D2

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
	
	if raycast.is_colliding() and raycast_down.is_colliding():
		raycast.enabled = false
		raycast_down.enabled = false
		BlockSet.get_node("Block_Sound").queue_free()
		_kill()
	
	if is_on_floor():
		
		if Input.is_action_pressed("ui_up"):	#skok
			get_node("Jump_Sound").play()
			motion.y = JUMP_HEIGHT
	
	motion = move_and_slide(motion, UP)#ruch wraz ze skokiem i zerowaniem prędkości

func _kill():
	$Sprite.hide()
	$AnimatedSprite.show()
	get_node("Death_Sound").play()
	$AnimatedSprite.playing = true