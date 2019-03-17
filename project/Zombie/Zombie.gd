extends KinematicBody2D

const MOVE_SPEED = 100

var health = 90

var player = null

func _ready():
	add_to_group("zombies")

func _physics_process(delta):
	delta *= 60.0
	
	if player == null:
		return
	
	var vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	global_rotation = atan2(vec_to_player.y, vec_to_player.x)
	move_and_slide(vec_to_player * MOVE_SPEED * delta)

func damage(dmg):
	health = health - dmg
	if (health<=0):
		self.kill()

func kill():
	queue_free()

func set_player(p):
	player = p