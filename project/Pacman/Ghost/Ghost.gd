extends KinematicBody2D

export var movementSpeed = 20
onready var timer = $Timer
enum States {NORMAL, CHASING_PACMAN, CHASING_PLAYER, RUNNING_AWAY}
var lastDirection = Vector2(-1,0)
onready var map = self.get_tree().get_root().get_node("/root/Root/LevelPacman/TileMap")
var currentState = States.NORMAL
var ableToTeleport = true
var astarPath = []
var targetPosition = Vector2()
var targetPointWorld = Vector2()
var velocity = Vector2()
onready var pacman = self.get_tree().get_root().get_node("/root/Root/LevelPacman/Pacman")
onready var startingPos = global_position

func _init():
	pass
	
func _ready():
	changeState(States.NORMAL)
	timer.connect("timeout", self, "_onTimer_timeout")

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
	if not ableToTeleport and timer.is_stopped():
		timer.start()
	
func changeState(newState):
	currentState = newState
	if newState == States.CHASING_PACMAN:
		astarPath = map.getPath(global_position, targetPosition)
		if not astarPath or len (astarPath) == 1:
			targetPosition = pacman.global_position
			return
		targetPointWorld = astarPath[0]
	if newState == States.NORMAL:
		astarPath = map.getPathToRandomTile(global_position, map.Modes.UPPER_HALF)
		if not astarPath or len (astarPath) == 1:
			return
		targetPointWorld = astarPath[0]
	if newState == States.RUNNING_AWAY:
		if pacman.isBoosted:
			print('run')
			astarPath = map.getPathToRunAwayFrom(global_position, pacman.global_position)
			if not astarPath or len (astarPath) == 1:
				return
		else:
			changeState(States.CHASING_PACMAN)
			
func moveTo(worldPosition):
	var ARRIVE_DISTANCE = 0.2
	var desiredVelocity = (worldPosition - global_position).normalized() * movementSpeed
	var steering = desiredVelocity - velocity
	velocity += steering
	lastDirection =  velocity.normalized()
	global_position += velocity * get_process_delta_time()
	return global_position.distance_to(worldPosition) < ARRIVE_DISTANCE

func _onTimer_timeout():
	ableToTeleport = true