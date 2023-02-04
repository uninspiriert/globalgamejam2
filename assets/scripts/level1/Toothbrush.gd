extends Area2D

onready var anim = $AnimationPlayer

func brush_bottom():
	$AnimationPlayer.current_animation = "brush_bottom"
	$AnimationPlayer.play()

func brush_sides():
	$AnimationPlayer.current_animation = "brush_sides"
	$AnimationPlayer.play()

func _on_Toothbrush_body_entered(body):
	if body.is_in_group("player"):
		body.receive_damage()
