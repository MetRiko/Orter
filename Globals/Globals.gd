extends Node

var currentScore = 0
var currentLevel = 0
var currentTime = 0
var currentLives = 0
var currentStage = null

var levelShield = 1
var levelSpeed = 1
var levelCooldown = 1
var levelLives = 1

var bestScore = 0
var bestTimes = []
var bestLevel = 0

var screenWidth = ProjectSettings.get_setting("display/window/size/width")
var screenHeight = ProjectSettings.get_setting("display/window/size/height")
onready var root = get_tree().get_root().get_node("Root")

func _ready():
	bestTimes.resize(root.levelsSettings.size()+1)
	resetStats()

func resetStats():
	currentScore = 0
	currentLevel = 0
	currentTime = 0
	currentLives = 0
	
	levelShield = 0
	levelSpeed = 1
	levelCooldown = 1
	levelLives = 1

#func _ready():
#    get_tree().get_root().connect("size_changed", self, "onSizeChanged")

#func onSizeChanged():	
#	screenWidth = get_viewport().size.x
#	screenHeight = get_viewport().size.y
