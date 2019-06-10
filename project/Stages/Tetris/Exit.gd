extends Node2D

onready var raycast = $RayCast2D

func _physics_process(delta):
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll.name == "Player":
			get_tree().quit()