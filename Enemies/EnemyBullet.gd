extends KinematicBody2D

var vel = Vector2(0.0, 6.0)

var screenWidth = ProjectSettings.get_setting("display/window/size/width")
var screenHeight = ProjectSettings.get_setting("display/window/size/height")

onready var currentStage = Globals.get_meta("currentStage")
onready var player = currentStage.getPlayer()

func setVelocity(_vel):
	vel = _vel

func _physics_process(delta):
	delta *= 60.0
	move(delta)
	
	if global_position.y > screenHeight:
		queue_free()
		
func move(delta):
	var result = move_and_collide(vel*delta)
	if result and result.collider.is_in_group("Shield"):
		result.collider.subHealth(1)
		queue_free()
	elif player.getHitbox().overlaps_body(self):
#		result.collider.damage(1)
		currentStage.subLive()
		queue_free()