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
var time = rand_range(0.0, 40.0)
onready var currentStage = Globals.currentStage

var health = 3

func _process(delta):
	time += delta
	wobble()
	
	delta *= 60.0
	
	if global_position.y > Globals.screenHeight:
		global_position.y = -40.0
		global_position.x = rand_range(40.0, Globals.screenWidth - 40.0)
		vel.y = 0.0
		
	vel.y = min(vel.y + acc, max_vel.y)
	move_and_collide(vel * delta)

	
func onCooldownTimer():
	pass
#	var rand = randi()%4
#	if rand == 0:
#		shoot()
#		$Timer.wait_time = rand_range(0.8, 1.6)
#		$Timer.start()

func shoot():
	var obj = BULLET.instance()
	currentStage.addProjectile(obj)
	obj.global_position = global_position

func _ready():
	randomize()
	$Timer.connect("timeout", self, "onCooldownTimer")
	setHealth(health)
	
	get_tree().create_timer(rand_range(2.0, 4.0)).connect("timeout", $Timer, "start")

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
	$Sprite.offset.x = 3.0 * sin(time * 8.0) 
