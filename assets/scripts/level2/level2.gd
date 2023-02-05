extends Node2D

onready var btnA = $QE/AButton
onready var btnB = $QE/BButton
onready var slider = $QE/Slider
onready var shaker = $Camera2D/ShakeCamera
var rem_hitpoints = 50
onready var lable_rem_hitpoints = $Camera2D/HBoxContainer/Value
var velocity :float = 0.0
var rndweight

func _ready():
	lable_rem_hitpoints.text = str(rem_hitpoints)
	rndweight = rand_range(-5, 5)
	velocity += rndweight
	pass

func _input(event):
	var inputval = 0.0
	if event.is_action("attack"):
		inputval = -10
	if event.is_action_pressed("attack"):
		rem_hitpoints -= 1
#		$AnimationPlayer.ANIMA
		btnA.scale = Vector2(9,9)
		$AnimationPlayer.play("Hit")
	if event.is_action_released("attack"):
		btnA.scale = Vector2(10,10)

	if event.is_action("dodge"):
		inputval = 10
	if event.is_action_pressed("dodge"):
		rem_hitpoints -= 1
#		$AnimationPlayer.stop("Hit")		
		btnB.scale = Vector2(9,9)
		$AnimationPlayer.play("Hit")
	if event.is_action_released("dodge"):
		btnB.scale = Vector2(10,10)
	velocity += inputval
	lable_rem_hitpoints.text = str(rem_hitpoints)

func _process(delta):
	slider.value += velocity*delta
	if rem_hitpoints == 0:
		pass
#		get_tree().change_scene_to()
