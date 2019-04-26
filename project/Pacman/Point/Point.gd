extends Sprite

signal pickup(object)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pickup", self, "_onPoint_pickup")
	
func _process(delta):
	var overlapped = $Area2D.get_overlapping_bodies()
	for object in overlapped:
		if object.is_in_group("player") or object.is_in_group("pacman"):
			emit_signal("pickup", object)
		

func _onPoint_pickup(object):
	queue_free()
