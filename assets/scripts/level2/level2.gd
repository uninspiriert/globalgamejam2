extends Node2D

onready var btnA = $"QE/HBoxContainer/Panel/HBoxContainer/Lane2/A-Button"
onready var btnB = $"QE/HBoxContainer/Panel/HBoxContainer/Lane3/B-Button"

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("attack"):
		btnA.scale = Vector2(9,9)
#		$ProgressbarTooth.value += 1
	if event.is_action_released("attack"):
		btnA.scale = Vector2(10,10)

	if event.is_action_pressed("dodge"):
		btnB.scale = Vector2(9,9)
	if event.is_action_released("dodge"):
		btnB.scale = Vector2(10,10)
