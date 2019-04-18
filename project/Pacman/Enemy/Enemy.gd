extends KinematicBody2D
export var projectileSpeed = 400.0
export var movementSpeed = 100.0
const POINT_RADIUS = 4
onready var isProjectile = false
var direction = Vector2()
var path : = PoolVector2Array() setget setPath

func _ready():
	pass

func _process(delta):
	if (isProjectile):
		var collision = move_and_slide(direction.normalized() * projectileSpeed * delta * 60.0)
	else:	
		if path.size() >= 0:
			var moveDistance = movementSpeed * delta
			moveAlongPath(moveDistance)
			

func setDirection(dir):
	direction = dir
	
func setPath(value : PoolVector2Array):
	path = value
	if value.size() <= 0:
		return
		

func moveAlongPath(distance : float):
	var startingPoint = self.position
	for i in range(self.path.size()):
		var distToNext = startingPoint.distance_to(path[0])
		if distance <= distToNext and distance >= 0:
			position = startingPoint.linear_interpolate(path[0], distance / distToNext)
#			var vec = path
			var mov = move_and_slide((path[0] - startingPoint ))
			
			break
		elif distance < 0.0:
			position = path[0]
			break
		distance -= distToNext
		startingPoint = path[0]
		path.remove(0)