extends Node

const STAGE = preload("res://Stages/Gameplay/GameplayStage.tscn")
const MAIN_MENU = preload("res://Stages/MainMenu/MainMenu.tscn")

var level = 0
var levelsSettings = [
	[ Vector2(8, 1),  [] ], # level 1
	[ Vector2(10, 1),  [{idx=0,time=5,health=2}] ], # level 2
	[ Vector2(12, 1),  [{idx=1,time=5,health=3}] ], # level 3
	[ Vector2(6, 2),  [{idx=2,time=5,health=4}] ], # level 4
	[ Vector2(8, 2),  [{idx=0,time=7,health=2},{idx=2,time=7,health=2}] ], # level 5
	[ Vector2(10, 2),  [{idx=2,time=7,health=3},{idx=3,time=7,health=3}] ], # level 6
	[ Vector2(12, 2), [{idx=1,time=4,health=2}] ], # level 7
	[ Vector2(8, 3),  [{idx=2,time=4,health=3}] ], # level 8
	[ Vector2(10, 3),  [{idx=0,time=10,health=2},{idx=1,time=10,health=2},{idx=2,time=10,health=2}] ], # level 9
	[ Vector2(12, 3), [{idx=0,time=10,health=3},{idx=3,time=10,health=3},{idx=2,time=10,health=3}] ], # level 10
	[ Vector2(8, 4),  [{idx=0,time=13,health=3},{idx=1,time=13,health=3},{idx=2,time=13,health=3},{idx=3,time=13,health=3}] ], # level 11
	[ Vector2(10, 4),  [{idx=0,time=13,health=4},{idx=1,time=13,health=4},{idx=2,time=13,health=4},{idx=3,time=13,health=4}] ], # level 12
	[ Vector2(12, 4), [{idx=0,time=13,health=5},{idx=1,time=13,health=5},{idx=2,time=13,health=5},{idx=3,time=13,health=5}] ] # level 13
]

var currentStage = null

func getBackground():
	return $Background

func playStage():
	if $Stage.get_child_count() > 0:
		var old = $Stage.get_child(0)
		old.queue_free()
		
	currentStage = STAGE.instance()
	currentStage.setConfig(levelsSettings[level][0])
	currentStage.setSettingDifficulty(levelsSettings[level][1])
	currentStage.setScore(Globals.currentScore)
	currentStage.setTime(Globals.currentTime)
	
#	if level == 0:
#		currentStage.setLives(4)
#	else:
#		currentStage.setLives(Globals.currentLives)		
		
	$Stage.add_child(currentStage)
	
	currentStage.setLives(Globals.levelLives * 2)
	currentStage.getPlayer().setSpeed(Globals.levelSpeed * 3.0 + 5.0)
	currentStage.getPlayer().setCooldown(0.9 * pow(0.82, Globals.levelCooldown))
	currentStage.setShieldHealth(Globals.levelShield * 4.0)
	
	currentStage.connect("gameOver", self, "_onGameOver")
	currentStage.connect("gameWin", self, "_onGameWin")

func _onGameOver():
#	playMainMenu().showGameOver()
	level = 0
	Globals.resetStats()
	playStage()

func _onGameWin():
#	playMainMenu().showWin()
	level = min(level + 1, levelsSettings.size()-1)
	Globals.currentLevel = level
	
	var op = level % 4
	if op == 0: Globals.levelSpeed += 2
	elif op == 1: Globals.levelCooldown += 2
	elif op == 2: Globals.levelShield += 1
	else: Globals.levelLives += 1
	
	playStage()

func playMainMenu():
	if $Stage.get_child_count() > 0:
		var old = $Stage.get_child(0)
		old.queue_free()
		
	currentStage = MAIN_MENU.instance()
	$Stage.add_child(currentStage)
	return currentStage
	