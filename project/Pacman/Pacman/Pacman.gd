extends KinematicBody2D

onready var normalPoint = preload("res://Pacman/Scenes/Point.tscn")
export var movementSpeed = 20
onready var timer = $Timer
enum States {NORMAL, CHASING_PLAYER, CHASING_GHOSTS, RUNNING_AWAY}
var lastDirection = Vector2(-1,0)
var map : TileMap
var currentState = States.NORMAL

var astarPath = []
const POINT_RADIUS = 3
var targetPosition = Vector2()
var targetPointWorld = Vector2()
var velocity = Vector2()


func _init():
	pass
	
func _ready():
	print('pac')
	map = get_parent().get_node("TileMap")
	timer.connect("timeout", self, "_onTimer_timeout")
	alignPosition()
	getPossibleDirections()
#	countPointsInRect(Vector2(-1,0))

func _process(delta):
	if Input.is_key_pressed(KEY_J):
		currentState = States.CHASING_PLAYER
	if Input.is_action_just_pressed("ui_page_up"):
		targetPosition = get_parent().get_node("Player").global_position
#		print(targetPosition)
		changeState(States.CHASING_PLAYER)
	if not currentState == States.CHASING_PLAYER:
		return
	var arrivedToNextPoint = moveTo(targetPointWorld)
	if arrivedToNextPoint:
		astarPath.remove(0)
		if len(astarPath) == 0:
			changeState(States.CHASING_PLAYER)
			return
		targetPointWorld = astarPath[0]
	

func _physics_process(delta):
	if currentState == States.NORMAL:
		var vel = move_and_slide(lastDirection * movementSpeed * delta * 60.0)
	#	print(vel, int(vel.x), int(vel.y))
		if int(vel.x) == 0 and int(vel.y) == 0 and timer.is_stopped():
			timer.start()
			
		var dirs = getPossibleDirections()
		var snapPrecision = 0.015625
	#	print(self.global_position, ', snapped -> ', self.global_position.snapped(Vector2(1,1)*snapPrecision), ' ', map.map_to_world(getCurrentTile()) + map.cell_size/2, 'dirs-> ', dirs)
		if dirs.size() > 0 and self.global_position.snapped(Vector2(1,1)*snapPrecision) == map.map_to_world(getCurrentTile()) + map.cell_size/2:
			alignPosition()
			lastDirection = getDirectionWithClosestPoint(dirs)
#	if currentState == States.CHASING_PLAYER:
#		if path.size() >= 0:
#			var moveDistance = movementSpeed * delta 
#			moveAlongPath(moveDistance)
	
func changeState(newState):
	if newState == States.CHASING_PLAYER:
		var toDisconnectIndex = map.calculatePointIndex(map.world_to_map(self.global_position - lastDirection * map.cell_size))
		map.pointToDisconnect = toDisconnectIndex
		var currentTileIndex = map.calculatePointIndex(map.world_to_map(self.global_position))
#		map.astar.set_point_weight_scale(toDisconnectIndex, 9001.0)
		astarPath = map.getPath(global_position, targetPosition)
		if not astarPath or len (astarPath) == 1:
#			changeState(States.NORMAL)
			print('cant find')
			targetPosition = get_parent().get_node("Player").global_position
			return
		targetPointWorld = astarPath[0]
	currentState = newState
	
func moveTo(worldPosition):
	var MASS = 1.0
	var ARRIVE_DISTANCE = 0.2
	var desiredVelocity = (worldPosition - global_position).normalized() * movementSpeed
#	print(lastDirection.normalized())
	var steering = desiredVelocity - velocity
	velocity += steering / MASS
	lastDirection =  velocity.normalized()
	global_position += velocity * get_process_delta_time()
	return global_position.distance_to(worldPosition) < ARRIVE_DISTANCE
func getPossibleDirections():
	var dirs = []
	var currentTile = getCurrentTile()
	for i in range (-1,2,2):
		if map.get_cell(currentTile.x+i, currentTile.y) == 2:
			if not lastDirection*-1 == Vector2(i,0):
				dirs.append(Vector2(i,0)) 
		if map.get_cell(currentTile.x, currentTile.y+i) == 2:
			if not lastDirection*-1 == Vector2(0,i):
				dirs.append(Vector2(0,i))
	return dirs
	
func getCurrentTile():
	return map.world_to_map(self.global_position)

func alignPosition():
	self.global_position = map.map_to_world(getCurrentTile()) + map.cell_size/2
	
func getDirectionWithClosestPoint(dirs : Array):
	randomize()
	var scaledDirs = []
	for dir in dirs:
		print()
	return dirs[randi()%dirs.size()]


#func moveAlongPath(distance : float):
#	var startingPoint = self.position
#	for i in range(self.path.size()):
#		var distToNext = startingPoint.distance_to(path[0])
#		if distance <= distToNext and distance >= 0:
#			var mov = move_and_slide((path[0] - startingPoint ).normalized()* movementSpeed)
#
#			break
#		elif distance < 0.0:
#			position = path[0]
#			break
#		distance -= distToNext
#		startingPoint = path[0]
#		path.remove(0)

func alignToTileCenter(pos : Vector2):
		return map.map_to_world(map.world_to_map(pos) + map.cell_size/2)

func _onTimer_timeout():
	alignPosition()
#	lastDirection = getDirectionWithClosestPoint(getPossibleDirections())
	