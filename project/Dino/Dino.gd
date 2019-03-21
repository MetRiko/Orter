extends RigidBody2D

export (int) var min_speed
export (int) var max_speed 

func _ready():
	$AnimatedSprite.play()
	
func _on_Visibility_screen_exited():
	queue_free()

