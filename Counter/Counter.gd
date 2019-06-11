tool
extends Node2D

export(int) var value = 100 setget setValue, getValue
export(bool) var countToRight = false setget setCountToRight

func setCountToRight(flag):
	countToRight = flag
	update()

func setValue(_value):
	value = _value
	update()
	
func getValue():
	return value

func getNumOfNums():
	var c = 0
	var v = value
	while v > 0:
		v /= 10
		c += 1
	return max(c, 1)

func _draw():
	var v = value
	var c = 0
	if countToRight == true: 
		c = $Nums.get_child_count() - getNumOfNums()
	
	for pos in $Nums.get_children():
		pos.visible = false
		
	if v == 0:
		var pos = $Nums.get_child(c)
		pos.frame = 0
		pos.visible = true
	else:
		while v > 0:
			var pos = $Nums.get_child(c)
			pos.frame = v % 10
			pos.visible = true
			v /= 10
			c += 1
		
func _ready():
	update()
		