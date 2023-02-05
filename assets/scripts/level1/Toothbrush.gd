extends Area2D

export(PackedScene) var foam;

onready var anim = $AnimationPlayer

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func brush_bottom():
	$AnimationPlayer.current_animation = "brush_bottom"
	$AnimationPlayer.play()

func brush_sides():
	$AnimationPlayer.current_animation = "brush_sides"
	$AnimationPlayer.play()

func _on_Toothbrush_body_entered(body):
	if body.is_in_group("player"):
		body.receive_damage()
		return

	if body.is_in_group("teeth") and rng.randi_range(1, 6) == 1:
		var f = foam.instance()
		get_parent().get_parent().add_child(f)
		f.global_position = body.global_position
		f.get_node("Particles2D").restart()
