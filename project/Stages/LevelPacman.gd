extends Node2D

onready var tilemap = $TileMap
onready var player = $Player
onready var ghosts = $Ghosts.get_children()
onready var pacman = $Pacman
onready var line_2d : Line2D = $Line2D

func _ready():
	$TileMap.connect("pickupPoint", self, "onTileMap_pickup")
	$TileMap.connect("pickupSuperPoint", self, "onTileMap_superPickup")
	$Pacman.connect("playerCollision", self, "onPacman_playerCollision")
	$Pacman.connect("ghostCollision", self, "onPacman_ghostCollision")
	
	$HUD/PacmanProgress.value = 0
	$HUD/PlayerProgress.value = 0
	
func _process(delta):
	line_2d.points = pacman.astarPath

func addPoint(pt):
	$Points.add_child(pt)
	
func addPortal(pt):
	$Portals.add_child(pt)

func onTileMap_pickup(objectName):
#	print("point <- ", objectName)
	if objectName == "pacman":
		$HUD/PacmanProgress.value += 1
	elif objectName == "player":
		$HUD/PlayerProgress.value += 1

func onTileMap_superPickup(objectName):
#	print("super point <- ", objectName)
	
	var object = null
	if objectName == "pacman":
		$HUD/PacmanProgress.value += 1
		object = $Pacman
	elif objectName == "player":
		$HUD/PlayerProgress.value += 1
		object = $Player

	object.isBoosted = true
	if object.is_in_group("pacman"):
		object.changeState(object.States.CHASING_GHOSTS)
	for ghost in ghosts:
		ghost.changeState(ghost.States.RUNNING_AWAY)
	object.boostTimer.start()
	
func onPacman_ghostCollision(object):
	if not object.get_node("Timer").is_stopped():
		object.global_position = $Ghosts.global_position
	else:
		$Pacman.global_position = Vector2(260, 110)

func onPacman_playerCollision():
	get_parent().restart()
