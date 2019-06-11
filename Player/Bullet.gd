extends KinematicBody2D

var vel = Vector2(0.0, -10.0)

func _physics_process(delta):
	delta *= 60.0
	move(delta)
	
	if global_position.y < 0.0:
		queue_free()
		
func move(delta):
	var result = move_and_collide(vel*delta)

	if result and result.collider.is_in_group("Enemy"):
		result.collider.damage(1)
		queue_free()
