extends Node2D

onready var btnA = $"QE/HBoxContainer/Panel/HBoxContainer/Lane2/A-Button"
onready var btnB = $"QE/HBoxContainer/Panel/HBoxContainer/Lane3/B-Button"
onready var shake = $Camera2D/ShakeCamera

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("attack"):
		btnA.scale = Vector2(9,9)
		shake.start()
		$AnimationPlayer.play("Hit")
#		$ProgressbarTooth.value += 1
	if event.is_action_released("attack"):
		btnA.scale = Vector2(10,10)

	if event.is_action_pressed("dodge"):
		btnB.scale = Vector2(9,9)
	if event.is_action_released("dodge"):
		btnB.scale = Vector2(10,10)

func _process(delta):
	
#func shakeit(node):
#	var tween : Tween = get_node("Tween")
#	var sprite = node
#	var shake = 5
#	var shake_duration = 0.3
#	var shake_count = 10
#
#	for i in shake_count:
#		tween.interpolate_property(sprite, "position", null, Vector2(rand_range(-shake, shake), rand_range(-shake, shake)), shake_duration)
#
#	tween.start()
