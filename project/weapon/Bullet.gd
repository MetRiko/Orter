extends KinematicBody2D

export var bulletDamage = 34
var vel = Vector2()

func setVelocity(vel):
	self.vel = vel
	
func _process(delta): # delta = 1/60s
	var collision = move_and_collide(vel * delta * 60.0)
	if collision:
		vel = vel.bounce(collision.normal)
		var collider = collision.collider
		if collider.is_in_group("Damageable"):
			collider.damage(bulletDamage)
#	global_position += vel * delta * 60.0