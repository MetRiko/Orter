extends KinematicBody2D

const BULLET = preload("res://Enemies/EnemyBullet.tscn")

signal death
signal hit

var max_vel = Vector2(0, 7)
var vel = Vector2()
var dir = 1.0
var acc = 0.1

const COLORS = [
	Color("ffffff"), # white
	Color("c40808"), # red
	Color("c4088b"),
	Color("8b08c4"),
	Color("4708c4"),
	Color("084cc4") # blue
]

onready var size = $Sprite.texture.get_size() * Vector2(1.0/$Sprite.hframes, 1.0/$Sprite.vframes) * $Sprite.get_scale()
var time = 0.0
onready var currentStage = Globals.currentStage

var rot = 0.0
const BULLETS_ROT = [0.0, 3.14159 * 0.5, 3.14159, 3.14159 * 1.5]

var health = 3

func _process(delta):
#	time += delta
#	wobble()
	
	rot += delta
	$Sprite.rotation = rot
	
	delta *= 60.0
	
#	if global_position.y > Globals.screenHeight:
#		global_position.y = -40.0
#		global_position.x = rand_range(40.0, Globals.screenWidth - 40.0)
#		vel.y = 0.0
#
#	vel.y = min(vel.y + acc, max_vel.y)
#	move_and_collide(vel * delta)

	
func onCooldownTimer():
	var rand = randi()%2
	if rand == 0:
		shoot()
		var wait = rand_range(0.8, 1.6)
		$Timer.wait_time = wait
		$Timer.start()

func shoot():
	var vel = Vector2(5.0, 0.0)
	
	for bulletRot in BULLETS_ROT:
		var obj = BULLET.instance()
		currentStage.addProjectile(obj)
		obj.setVelocity(vel.rotated(rot + bulletRot))
		obj.rotation = rot + bulletRot - 3.14159 * 0.5
		obj.global_position = global_position

func _ready():
	randomize()
	$Timer.connect("timeout", self, "onCooldownTimer")
	setHealth(health)
	
	get_tree().create_timer(rand_range(0.4, 0.8)).connect("timeout", $Timer, "start")

func setHealth(value):
	health = value
	$Sprite.modulate = COLORS[health]

func damage(value):
	setHealth(health - value)
	emit_signal("hit")
	if health <= 0:
		$Timer.stop()
		emit_signal("death")
		queue_free()

func wobble():
	$Sprite.offset.y = 3.0 * sin(time * 4.0) 
