extends Node2D

onready var tilemap = $TileMap
onready var player = $Player
onready var ghosts = $Ghosts.get_children()
onready var pacman = $Pacman
onready var line_2d : Line2D = $Line2D

func _ready():
	pass
	
func _process(delta):
	line_2d.points = pacman.astarPath

func addPoint(pt):
	$Points.add_child(pt)
	
func addPortal(pt):
	$Portals.add_child(pt)
