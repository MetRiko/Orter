extends Node2D

onready var root = get_tree().get_root().get_node("Root")

var stage = null

var upgradeTime = true
var upgraded = false

var newRecordForScore = false
var newRecordForLevel = false
var newRecordForTime = false

onready var gameOver = $GameOver

func showGameOver():
	gameOver.frame = 1
	gameOver.visible = true
	$Text.visible = true
	gameOver.modulate = Color("d40000")

func _process(delta):
	$NewRecord.visible = newRecordForLevel or newRecordForScore or newRecordForTime
	if newRecordForScore: $Text/Score.modulate = $NewRecord.modulate
	if newRecordForTime: $Text/Time.modulate = $NewRecord.modulate
	if newRecordForLevel: $Text/Level.modulate = $NewRecord.modulate

func showWin():
	gameOver.frame = 2
	gameOver.visible = true
	$Text.visible = true
	gameOver.modulate = Color("00d453")
	switchUpgradeTime(true)
	checkRecords()

func checkRecords():
	if Globals.currentScore > Globals.bestScore:
		Globals.bestScore = Globals.currentScore
		newRecordForScore = true
	if Globals.currentLevel+1 > Globals.bestLevel:
		Globals.bestLevel = Globals.currentLevel
		newRecordForLevel = true
	if Globals.bestTimes[Globals.currentLevel] == null or Globals.bestTimes[Globals.currentLevel] > Globals.currentTime:
		Globals.bestTimes[Globals.currentLevel] = Globals.currentTime
		newRecordForTime = true

func _ready():
	switchUpgradeTime(false)
	
	$Text/ScoreCounter.value = Globals.currentScore
	$Text/TimeCounter.value = Globals.currentTime
	$Text/LevelCounter.value = Globals.currentLevel + 1
	
	$Text.visible = false
	gameOver.visible = false
	root.getBackground().connect("blink", self, "onBackground_blink")

	$Upgrades/Speed.connect("clicked", self, "upgrade", [0])
	$Upgrades/Cooldown.connect("clicked", self, "upgrade", [1])
	$Upgrades/Shield.connect("clicked", self, "upgrade", [2])
	$Upgrades/Life.connect("clicked", self, "upgrade", [3])
	
	$Upgrades/Speed.changeIcon(0)
	$Upgrades/Cooldown.changeIcon(1)
	$Upgrades/Shield.changeIcon(2)
	$Upgrades/Life.changeIcon(3)
	
#	showWin()

func switchUpgradeTime(flag):
	upgradeTime = flag
	$Sprite.visible = not flag
	$Upgrades.visible = flag

func upgrade(idx): # speed, cooldown, shield, life
	if upgradeTime == true:
		if idx == 0:
			Globals.levelSpeed += 1
		elif idx == 1:
			Globals.levelCooldown += 1
		elif idx == 2:
			Globals.levelShield += 1
		elif idx == 3:
			Globals.levelLives += 1
		upgraded = true

func onBackground_blink():
	root.playStage()
	stage = Globals.get_meta("currentStage")
#	stage.modulate.a = 0.0

func _input(event):
	if event.is_action_pressed("touch"):
		if upgraded == true and event.is_action_pressed("touch"):
			switchUpgradeTime(false)
			upgraded = false
		elif upgradeTime == false and event.is_action_pressed("touch"):
			var back = root.getBackground()
			back.playLightspeedJump()
			$Anim.play("Hide", 0.05)
			$Tween.interpolate_property($GameOver, "modulate:a", $GameOver.modulate.a, 0.0, 0.8, Tween.TRANS_CUBIC, Tween.EASE_OUT)
			$Tween.start()
			
			$Tween.interpolate_property($NewRecord, "modulate:a", $NewRecord.modulate.a, 0.0, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.4)
			$Tween.start()
			$NewRecord/Anim.stop()
			$Tween.interpolate_property($Text, "modulate:a", $Text.modulate.a, 0.0, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.4)
			$Tween.start()