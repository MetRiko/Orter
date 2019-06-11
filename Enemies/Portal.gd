extends Node2D

func _ready():
	$Anim.connect("animation_finished", self, "onAnim_finished")
	
func onAnim_finished(anim):
	queue_free()