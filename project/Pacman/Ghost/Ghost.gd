extends KinematicBody2D

export var movementSpeed = 20
enum States {NORMAL, CHASING_PACMAN, CHASING_PLAYER, RUNNING_AWAY}
var lastDirection = Vector2(-1,0)
var map : TileMap
var currentState = States.NORMAL

var astarPath = []
var targetPosition = Vector2()
var targetPointWorld = Vector2()
var velocity = Vector2()
onready var pacman = get_parent().get_parent().get_node("Pacman")

func _init():
	pass
	
func _ready():
	map = get_parent().get_parent().get_node("TileMap")
	changeState(States.NORMAL)

func _process(delta):
	if Input.is_key_pressed(KEY_J):
		currentState = States.CHASING_PACMAN
	if Input.is_action_just_pressed("ui_page_down"):
		targetPosition = pacman.global_position
		changeState(States.CHASING_PACMAN)
	var arrivedToNextPoint = moveTo(targetPointWorld)
	if arrivedToNextPoint:
		astarPath.remove(0)
		if len(astarPath) == 0:
			changeState(States.CHASING_PACMAN)
			return
		targetPointWorld = astarPath[0]
	
func changeState(newState):
	currentState = newState
	if newState == States.CHASING_PACMAN:
		astarPath = map.getPath(global_position, targetPosition)
		if not astarPath or len (astarPath) == 1:
#			changeState(States.NORMAL)
			print('cant find')
			targetPosition = pacman.global_position
			return
		targetPointWorld = astarPath[0]
	if newState == States.NORMAL:
		astarPath = map.getPathToRandomTile(global_position, map.Modes.UPPER_HALF)
		if not astarPath or len (astarPath) == 1:
			print('cant find')
			return
		targetPointWorld = astarPath[0]

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
