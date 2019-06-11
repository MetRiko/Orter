extends Node

const LEVEL = preload("res://Stages/LevelPacman.tscn")

var level = null

var doRestart = false

func _ready():
	level = $LevelPacman

func _process(delta):
	if doRestart == true:
		doRestart = false
		level.queue_free()
		level = LEVEL.instance()
		add_child(level)
	
func restart():
	doRestart = true
	