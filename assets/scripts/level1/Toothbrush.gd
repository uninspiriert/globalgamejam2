extends Area2D

onready var anim = $AnimationPlayer

func brush():
	$AnimationPlayer.current_animation = "brush"
	$AnimationPlayer.play()
