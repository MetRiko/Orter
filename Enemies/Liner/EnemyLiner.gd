extends KinematicBody2D

const BULLET = preload("res://Enemies/EnemyBullet.tscn")

signal death
signal hit

var max_vel = Vector2(5, 0)
var vel = Vector2()
var dir = 1.0
var acc = 0.5

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

var health = 3

func _process(delta):
	time += delta
	wobble()
	
	delta *= 60.0
	
	if global_position.x < 0:
		dir = 1.0
		acc = 2.0
	elif global_position.x > Globals.screenWidth:
		dir = -1.0
		acc = 2.0
	else:
		acc = 0.5
		
	vel.x = clamp(vel.x + acc * dir, -max_vel.x, max_vel.x)
	move_and_collide(vel * delta)

	
func onCooldownTimer():
	var rand = randi()%2
	if rand == 0:
		shoot()
		$Timer.wait_time = rand_range(1.2, 1.8)
		$Timer.start()

func shoot():
	for i in range(4):
		var obj = BULLET.instance()
		currentStage.addProjectile(obj)
		obj.setVelocity(Vector2(rand_range(-0.5, 0.5), rand_range(10.0, 15.0)))
		obj.global_position = global_position
		yield(get_tree().create_timer(0.05), "timeout")

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