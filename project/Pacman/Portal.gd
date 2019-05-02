extends Area2D

signal teleport(object)

onready var timer = $Timer
onready var portals = get_parent().get_children()

func _ready():
	self.connect("teleport", self, "_onPortal_enter")
	for i in range(portals.size()):
		if portals[i].name == self.name:
			portals.remove(i)
			break

func _onPortal_enter(object):
	if timer.is_stopped() and object.ableToTeleport:
		var destination = getOtherPortal()
		object.global_position = destination.global_position
		if object.is_in_group('pacman') or object.is_in_group('ghosts'):
			object.changeState(object.currentState)
		object.ableToTeleport = false
		timer.start()
	
func getOtherPortal():
	return portals[randi() % self.portals.size()]

func _process(delta):
	var overlapped = get_overlapping_bodies()
	for object in overlapped:
		if object.is_in_group("player") or object.is_in_group("pacman") or object.is_in_group('ghosts'):
			emit_signal("teleport", object)
