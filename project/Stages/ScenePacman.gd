extends Node2D

onready var nav = $Navigation2D
onready var tilemap = $Navigation2D/TileMap
onready var player = $Player
onready var enemies = $Enemies.get_children()

func _ready():
	initTiles()
	pass
	
func initTiles():
	print('Initializing navigational tiles')
	var tile = tilemap.get_used_rect()
	for i in range (tile.size.x):
		for j in range (tile.size.y):
			var x = tile.position.x+i
			var y = tile.position.y+j
			if tilemap.get_cell(x,y) == -1:
				tilemap.set_cell(x,y,4)
				

func _process(delta):
	enemies = $Enemies.get_children()
	for enemy in enemies:
		if(enemy != null):
			var newPath = nav.get_simple_path(enemy.global_position, player.global_position, false)
			enemy.path = newPath
			
	
func spawnProjectile(projectile):
	$Enemies.add_child(projectile)
	