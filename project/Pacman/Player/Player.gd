extends KinematicBody2D
export var movementSpeed = 300.0

onready var timer = $Timer

var loaded = false
var lastDirection = Vector2()
var direction = Vector2()
var ableToTeleport = true


func _ready():
	timer.connect("timeout", self, "_onTimer_timeout")

func _process(delta):
	direction = Vector2()
	handleInput()
	self.move_and_slide(direction.normalized() * movementSpeed * delta * 60.0)
	update()
	if not ableToTeleport and timer.is_stopped():
		timer.start()

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
		
func _onTimer_timeout():
	ableToTeleport = true