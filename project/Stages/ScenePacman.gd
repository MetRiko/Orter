extends Node2D

onready var nav = $Navigation2D
onready var tileMap = $Navigation2D/TileMap
onready var player = $Player
onready var enemies = $Enemies.get_children()

func _ready():
	pass
	
func _process(delta):
	enemies = $Enemies.get_children()
	for enemy in enemies:
		if(enemy != null):
			var newPath = nav.get_simple_path(enemy.global_position, player.global_position)
			enemy.path = newPath
			
	
func spawnProjectile(projectile):
	$Enemies.add_child(projectile)
	