extends KinematicBody2D

const BULLET = preload("res://Enemies/EnemyBullet.tscn")

signal death
signal hit

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
onready var currentStage = Globals.get_meta("currentStage")

var health = 1

func onCooldownTimer():
	var counter = max(int(Globals.get_meta("enemyCounter") * 0.5), 1)
	var rand = randi()%counter
	if rand == 0:
		shoot()
		$CooldownTimer.wait_time = rand_range(1.0, 3.0)
		$CooldownTimer.start()
		
func shoot():
	var obj = BULLET.instance()
	currentStage.addProjectile(obj)
#	obj.setVelocity(Vector2(rand_range(-4.0, 4.0), rand_range(5.0, 10.0)))
	obj.setVelocity(Vector2(0.0, rand_range(5.0, 10.0)))
	obj.global_position = global_position

func _ready():
	randomize()
	$CooldownTimer.connect("timeout", self, "onCooldownTimer")
	setHealth(1)
	
	get_tree().create_timer(rand_range(2.0, 4.0)).connect("timeout", $CooldownTimer, "start")
	
	$Anim.play("Idle", -1, rand_range(0.8, 1.2))
	$Anim.seek(rand_range(0.0, 1.0), true)

func setHealth(value):
	health = value
	$Sprite.modulate = COLORS[health]
		
#	$Sprite.frame = clamp(health - 1, 0, 3)

func damage(value):
	setHealth(health - value)
	emit_signal("hit")
	if health <= 0:
		emit_signal("death")
		queue_free()

func _process(delta):
	time += delta
	wobble()

func wobble():
	$Sprite.offset.y = 3.0 * sin(time * 4.0) 
