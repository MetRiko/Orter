tool
extends Node2D

export(int) var value = 0 setget setValue, getValue

func setValue(_value):
	value = _value
	update()
	
func getValue():
	return value

func _draw():
	for live in $Lives.get_children():
		live.visible = value > live.get_index()

#func _init():
#	var spr = $Lives/Sprite
#	for i in range(20):
#		var obj = spr.duplicate()
#		$Lives.add_child(obj)
#		obj.position.x = i * 12.0

func _ready():
	var spr = $Lives/Sprite
	for i in range(20):
		var obj = spr.duplicate()
		$Lives.add_child(obj)
		obj.position.x = i * 12.0 + 12.0
		
