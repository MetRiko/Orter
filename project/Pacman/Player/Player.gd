extends KinematicBody2D
export var movementSpeed = 300.0
export var interactionRange = 16.0

onready var enemyScene = preload("res://Pacman/Enemy/Enemy.tscn")
onready var rc = self.get_node('rc')

var loaded = false
var lastDirection = Vector2()
var direction = Vector2()



func _ready():
	rc.enabled = true	

func _process(delta):
	direction = Vector2()
	handleInput()
	self.move_and_slide(direction.normalized() * movementSpeed * delta * 60.0)
	update()
	pass
	
func _draw():
	draw_line(rc.position, lastDirection.normalized() * interactionRange + rc.position, Color.green)

func handleInput():
	if Input.is_action_pressed("ui_left"):
		direction += Vector2(-1,0)
		$Sprite.scale.x = -1
	elif Input.is_action_pressed("ui_right"):
		direction += Vector2(1,0)
		$Sprite.scale.x = 1
	if Input.is_action_pressed("ui_down"):
		direction += Vector2(0,1)
	elif Input.is_action_pressed("ui_up"):
		direction += Vector2(0,-1)
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if direction != Vector2():
		lastDirection = direction
		