extends Node2D

var Dino = load("res://Dino/Dino.tscn")


func _ready():
	$DinoTimer.start()
	
func game_over():
	$DinoTimer.stop()

func _on_DinoTimer_timeout():
	$DinoPath/DinoSpawnLocation.set_offset(randi())
	var dino = Dino.instance()
	add_child(dino)
	var direction = $DinoPath/DinoSpawnLocation.rotation + PI / 2
	dino.position = $DinoPath/DinoSpawnLocation.position
	dino.set_linear_velocity(Vector2(rand_range(dino.min_speed, dino.max_speed), 0).rotated(direction))