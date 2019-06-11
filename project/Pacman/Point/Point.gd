extends Sprite

signal pickup

#func _ready():
#	self.connect("pickup", self, "_onPoint_pickup")
	
func _process(delta):
	var overlapped = $Area2D.get_overlapping_bodies()
	for object in overlapped:
		if object.is_in_group("player"):
			emit_signal("pickup", "player")
			queue_free()		
		elif object.is_in_group("pacman"):
			emit_signal("pickup", "pacman")
			queue_free()
		
