extends Node2D

signal blink

var doJump = false

func playLightspeedJump():
	doJump = true
	$Anim.play("Jump", 0.5)
	yield($Anim, "animation_finished")
	$Anim.play("Idle")