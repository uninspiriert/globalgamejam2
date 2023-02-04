extends Area2D

onready var anim = $AnimationPlayer

func brush_bottom():
	$AnimationPlayer.current_animation = "brush_bottom"
	$AnimationPlayer.play()

func brush_sides():
	$AnimationPlayer.current_animation = "brush_sides"
	$AnimationPlayer.play()
