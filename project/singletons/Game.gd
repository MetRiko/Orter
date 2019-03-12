extends Node

onready var nRoot = get_tree().get_root().get_node("Root")

func getCurrentStage():
	return nRoot.get_node("Level")
