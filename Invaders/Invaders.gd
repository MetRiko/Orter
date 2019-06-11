extends Position2D

signal bottomBorderAchived
signal enemiesCleared
signal enemyDeath
signal enemyHit

const INVADER = preload("res://Enemies/Enemy.tscn")

var maxVel = Vector2(50, 30)
#var maxVel = Vector2(120, 50)
const ACCELERATION = Vector2(3, 1)

#var screenWidth = ProjectSettings.get_setting("display/window/size/width")
#var screenHeight = ProjectSettings.get_setting("display/window/size/height")

var velocity = Vector2(0, 0)
var direction = Vector2(1, 1)
var counter = 0

var formationSize = Vector2(1,1)

func setEnemyCounter(value):
	counter = value
	Globals.set_meta("enemyCounter", counter)

func createGrid(size):
	formationSize = size
	for y in range(size.y):
		for x in range(size.x):
			var newPos = Vector2(x, y)
			var invader = createInvader()
			invader.position = (newPos * invader.size) - Vector2(x*5, y*5)
			invader.time = x
			invader.setHealth(size.y-y)
			
	setEnemyCounter(size.x * size.y)

func onEnemy_death():
	setEnemyCounter(max(counter - 1, 0))
	maxVel.x += 3.0
	emit_signal("enemyDeath")
	if counter == 0:
		emit_signal("enemiesCleared")

func createInvader():
	var invader = INVADER.instance()
	invader.connect("death", self, "onEnemy_death")
	invader.connect("hit", self, "emit_signal", ["enemyHit"])
	add_child(invader)
	return invader

func moveFormation(delta):
	applyHorizontalAcceleration()
	applyVerticalAcceleration()
	position += velocity * delta

func applyHorizontalAcceleration():
	velocity.x = clamp(velocity.x + ACCELERATION.x * sign(direction.x), -maxVel.x, maxVel.x)

func applyVerticalAcceleration():
	if abs(velocity.x) < maxVel.x:
		velocity.y = min(velocity.y + ACCELERATION.y, maxVel.y)
	else:
		velocity.y = 0.0
		direction.y = 0.0

func checkBorderReached():
	for invader in get_children():
		if hitLeftBorder(invader) or hitRightBorder(invader):
			direction.x = -direction.x
			direction.y = 8.0
			break

func hitLeftBorder(invader):
	return direction.x < 0.0 and invader.global_position.x < invader.size.x * 1.5

func hitRightBorder(invader):
	return direction.x > 0.0 and invader.global_position.x > Globals.screenWidth - (invader.size.x * 1.5)

func checkBottomBorder():
	for invader in get_children():
		if invader.global_position.y > Globals.screenHeight:
			direction = Vector2(0, 0)
			velocity = Vector2(0, 0)
			emit_signal("bottomBorderAchived")
			break

func _process(delta):
	moveFormation(delta)
	checkBorderReached()
	checkBottomBorder()
