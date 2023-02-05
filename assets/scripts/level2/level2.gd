extends Node2D

onready var btnA = $QE/AButton
onready var btnB = $QE/BButton
onready var slider = $QE/Slider
onready var shaker = $Camera2D/ShakeCamera
onready var gamewon = load("res://assets/scenes/GameEnd.tscn")
onready var gameover = load("res://assets/scenes/GameOver.tscn")
var rem_hitpoints = 30
onready var lable_rem_hitpoints = $Camera2D/HBoxContainer/Value
var velocity :float = 0.0
var rndweight
var countdown = 3
export(PackedScene) var bloodspawn

func _ready():
	get_tree().paused = true
	lable_rem_hitpoints.text = str(rem_hitpoints)
	rndweight = rand_range(-15, 15)
	velocity += rndweight
	pass
	
func showmessage(message):
	$QE/Message.text = str(message)

func _input(event):
	var rndpower = rand_range(0,10)
	var inputval = 0.0
	if event.is_action("attack"):
		inputval = -(20+rndpower)
	if event.is_action_pressed("attack"):
		rem_hitpoints -= 1
		btnA.scale = Vector2(9,9)
		$AnimationPlayer.play("Hit")
	if event.is_action_released("attack"):
		btnA.scale = Vector2(10,10)

	if event.is_action("dodge"):
		inputval = 20+rndpower
	if event.is_action_pressed("dodge"):
		rem_hitpoints -= 1
		btnB.scale = Vector2(9,9)
		$AnimationPlayer.play("Hit")
	if event.is_action_released("dodge"):
		btnB.scale = Vector2(10,10)
	velocity += inputval
	if rem_hitpoints >= 0:
		lable_rem_hitpoints.text = str(rem_hitpoints)

func _process(delta):
	var inc_vel = 0.0
	if slider.value <= 50:
		inc_vel = 1+(51-slider.value)/1000
	else:
		inc_vel = 1+(slider.value-50)/1000
	velocity *= inc_vel
	slider.value += velocity*delta
	if slider.value == 0 or slider.value == 100:
		if $Tooth.visible == false:
			pass
		else:
			var _gameover = get_tree().change_scene_to(gameover)
	if rem_hitpoints == 0:
		level_success()


func level_success():
	if $Tooth.visible == true:
		$Tooth.hide()
		$ToothRight.hide()
		$Toof.show()
		var spawnblood = bloodspawn.instance()
		spawnblood.position = $Bloodspawn.position
		spawnblood.scale = Vector2(10,10)
		add_child(spawnblood)
		$AnimationPlayerEnd.play("TakeOff")

func _on_StartTimer_timeout():
	if countdown > 0:
		var text = str(countdown) + "..."
		showmessage(text)
		countdown -= 1
	else:
		$QE/Message.hide()
		get_tree().paused = false
		


func _on_VisibilityNotifier2D_screen_exited():
	$SceneChange.start()
	$Toof.queue_free()
	


func _on_SceneChange_timeout():
	var _gamewon = get_tree().change_scene_to(gamewon)
