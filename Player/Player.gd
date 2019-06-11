extends Node2D

signal collisionWithEnemy

const BULLET = preload("res://Player/Bullet.tscn")

var screenWidth = ProjectSettings.get_setting("display/window/size/width")

var leftBorder = 0.0
var rightBorder = 0.0
var reloading = 0.0
var speed = 10.0 # 10 - 50
#var cooldown = 0.4 # 0.8 - 0.2

func setSpeed(value):
	speed = value

func setCooldown(value):
	$CooldownTimer.wait_time = value
	$CooldownTimer.start()

func _ready():
	$Hitbox.connect("body_entered", self, "_onHitbox")
	
	var halfSize = $Sprite.get_texture().get_size() * $Sprite.scale * 0.5
	leftBorder = halfSize.x * 2.0
	rightBorder = screenWidth - halfSize.x * 2.0

func _onHitbox(body):
	if body.is_in_group("Enemy"):
		emit_signal("collisionWithEnemy")

func _process(delta):
	if Input.is_action_pressed("touch"):
		var mousePos = get_global_mouse_position()
		setHorizontalPosition(mousePos.x)
	fire()

func getHitbox():
	return $Hitbox

func setHorizontalPosition(pos):
	var vec = pos - global_position.x
	var dis = min(abs(vec), 50.0)
	if dis > 5.0:
		global_position.x += speed * dis * 0.01 * sign(vec)
		if global_position.x <= leftBorder:
			global_position.x = leftBorder
		elif global_position.x >= rightBorder:
			global_position.x = rightBorder
		
	
#	global_position.x = clamp(pos, leftBorder, rightBorder)

func move(adjustment):
	var newX = position.x + adjustment.x
	if newX <= leftBorder:
		newX = leftBorder
	elif newX >= rightBorder:
		newX = rightBorder
	position.x = newX

func fire():
	if $CooldownTimer.is_stopped():
		var bullet = BULLET.instance()
		bullet.global_position = global_position
		get_parent().addProjectile(bullet)
		$CooldownTimer.start()