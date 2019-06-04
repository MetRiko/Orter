extends Node2D

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_released("ui_r"):
		get_tree().reload_current_scene()