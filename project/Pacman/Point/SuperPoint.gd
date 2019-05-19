extends Sprite

signal pickup(object)

func _ready():
	self.connect("pickup", self, "_onPoint_pickup")
	
func _process(delta):
	var overlapped = $Area2D.get_overlapping_bodies()
	for object in overlapped:
		if object.is_in_group("player") or object.is_in_group("pacman"):
			emit_signal("pickup", object)
		

func _onPoint_pickup(object):
	object.isBoosted = true
	if object.is_in_group("pacman"):
		object.changeState(object.States.CHASING_GHOSTS)
	object.boostTimer.start()
	queue_free()
