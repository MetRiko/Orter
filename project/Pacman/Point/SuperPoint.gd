extends Sprite

signal pickup

# onready var ghosts = self.get_tree().get_root().get_node("/root/Root/LevelPacman/Ghosts").get_children()

# func _ready():
	# self.connect("pickup", self, "_onPoint_pickup")
	
func _process(delta):
	var overlapped = $Area2D.get_overlapping_bodies()
	for object in overlapped:
		if object.is_in_group("player"):
			emit_signal("pickup", "player")
			queue_free()		
		elif object.is_in_group("pacman"):
			emit_signal("pickup", "pacman")
			queue_free()
		

# func _onPoint_pickup(object):
	# object.isBoosted = true
	# if object.is_in_group("pacman"):
	# 	object.changeState(object.States.CHASING_GHOSTS)
	# 	for ghost in ghosts:
	# 		ghost.changeState(ghost.States.RUNNING_AWAY)
	# object.boostTimer.start()
	# queue_free()