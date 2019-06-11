extends Node2D

signal clicked

func changeIcon(idx):
	$Sprite.frame = idx

func _input(event):
	if event.is_action_pressed("touch"):
		var halfSize = $CollisionShape2D.shape.extents * get_global_transform_with_canvas().get_scale()
		var rect = Rect2(global_position - halfSize, halfSize * 2.0)
		if rect.has_point(get_global_mouse_position()):
			emit_signal("clicked")
#			print("yey")