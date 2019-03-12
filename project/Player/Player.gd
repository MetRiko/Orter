extends KinematicBody2D

var vel = Vector2()

func _process(delta):
	vel = Vector2()
	if Input.is_action_pressed("ui_left"):
		vel.x = -1.0
	if Input.is_action_pressed("ui_right"):
		vel.x = 1.0
	if Input.is_action_pressed("ui_up"):
		vel.y = -1.0
	if Input.is_action_pressed("ui_down"):
		vel.y = 1.0
		
	move_and_slide(vel.normalized()*200.0)