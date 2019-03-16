extends KinematicBody2D

var vel = Vector2()

func setVelocity(vel):
	self.vel = vel
	
func _process(delta): # delta = 1/60s
	var collision = move_and_collide(vel * delta * 60.0)
	if collision:
		vel = Vector2()
		var collider = collision.get_collider()
		if collider.name == "Zombie":
			collider.damage(30)
		self.kill()
#	global_position += vel * delta * 60.0

func kill():
	queue_free()