extends AnimatedSprite

func _ready():
	connect("animation_finished", self, "on_AnimatedSprite_animation_finished")

func on_AnimatedSprite_animation_finished():
	get_parent().queue_free()