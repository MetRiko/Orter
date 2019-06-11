extends Node2D

const ENEMIES = [
	preload("res://Enemies/Liner/EnemyLiner.tscn"),
	preload("res://Enemies/Kami/EnemyKami.tscn"),
	preload("res://Enemies/Multi/EnemyMulti.tscn"),
	preload("res://Enemies/Pend/EnemyPend.tscn")
]

signal gameOver
signal gameWin

var lives = 4
var config = Vector2(12, 4)

var time = 0
var score = 0

var setting = [
	{ idx = 0, time = 4.0, health = 1 },
	{ idx = 1, time = 4.0, health = 1 },
	{ idx = 2, time = 4.0, health = 1 },
	{ idx = 3, time = 4.0, health = 1 }
]

func _onSpawnTimer(timer):
	var timerIdx = timer.get_index()
	var time = setting[timerIdx].time
	var health = setting[timerIdx].health
	var enemyIdx = setting[timerIdx].idx
	
	spawnEnemy(enemyIdx, randi()%health + 1)
	timer.wait_time = rand_range(time * 0.75, time * 1.25)
	timer.start()

func spawnEnemy(idx, health):
	var enemy = createEnemy(idx)
	enemy.setHealth(health)
	
	if idx == 0:
		enemy.global_position = Vector2(rand_range(40.0, Globals.screenWidth - 40.0), rand_range(40.0, 200.0))
	elif idx == 1:
		enemy.global_position = Vector2(rand_range(40.0, Globals.screenWidth - 40.0), rand_range(20.0, 80.0))
	elif idx == 2:
		enemy.global_position = Vector2(rand_range(90.0, Globals.screenWidth-90.0), rand_range(120.0, 400.0))
	elif idx == 3:
		enemy.global_position = Vector2(rand_range(120.0, Globals.screenWidth-120.0), rand_range(180.0, 300.0))

func setSettingDifficulty(_setting):
	setting = _setting
	
	for timer in $SpawnTimers.get_children():
		timer.stop()
		
	for i in range(setting.size()):
		var timer = $SpawnTimers.get_child(i)
		timer.wait_time = rand_range(setting[i].time * 0.75, setting[i].time * 1.25)
		timer.start()

func getTime():
	return time
	
func getScore():
	return score

func setTime(_time):
	time = _time
	update()
	
func setScore(_score):
	score = _score
	update()

func addScore(value):
	setScore(score + 1)

func setConfig(_config):
	config = _config

func setLives(value):
	lives = value
	$Hud/LiveCounter.value = max(value - 1, 0)
	if lives <= 0:
		gameOver()

func gameOver():
	Globals.currentScore = score
	Globals.currentTime = time
	emit_signal("gameOver")
	
func gameWin():
	Globals.currentScore = score
	Globals.currentTime = time
	Globals.currentLives = lives
	emit_signal("gameWin")

func getPlayer():
	return $Player

func subLive():
	setLives(lives - 1)

func _init():
	Globals.currentStage = self

func setShieldHealth(value):
	for shield in $Shields.get_children():
		shield.setHealth(value)

func _ready():
	Globals.set_meta("currentStage", self)
	$Invaders.connect("bottomBorderAchived", self, "gameOver")
	$Invaders.connect("enemiesCleared", self, "gameWin")
	$Invaders.connect("enemyHit", self, "addScore", [1])
	$Player.connect("collisionWithEnemy", self, "gameOver")
	$Timer.connect("timeout", self, "_onTimer")
	
	for timer in $SpawnTimers.get_children():
		timer.connect("timeout", self, "_onSpawnTimer", [timer])
	
	$Invaders.createGrid(config)
		
	setShieldHealth(1)
	setSettingDifficulty(setting)
	setLives(lives)
	
	modulate.a = 0.0
	$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.start()
	
	$Hud/Text/ScoreCounter.value = Globals.currentScore
	$Hud/Text/TimeCounter.value = Globals.currentTime
	
	$Player.setSpeed(50.0) # 10 - 50
	$Player.setCooldown(0.2) # 0.8 - 0.2
	
#	$Player.position = Vector2(40, 550)

func addProjectile(node):
	$Projectiles.add_child(node)
	
func _onTimer():
	setTime(time + 1)

func createEnemy(idx):
	var obj = ENEMIES[idx].instance()
	$Enemies.add_child(obj)
	obj.connect("hit", self, "addScore", [1])
	return obj

#func _input(event):
#	if event.is_action_pressed("ui_select"):
#		spawnEnemy(randi()%ENEMIES.size(), 3)
#	if event.is_action_pressed("ui_left"):
#		gameWin()
#		createEnemy(randi()%ENEMIES.size()).global_position = get_global_mouse_position()
#		createEnemy(randi()%ENEMIES.size()).global_position = get_global_mouse_position()
	
func _draw():
	$Hud/Text/ScoreCounter.value = score
	$Hud/Text/TimeCounter.value = time