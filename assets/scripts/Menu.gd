extends CanvasLayer

onready var btnStart = $VBoxContainer/HContainer/PanelLinks/CenterContainer/VBoxContainer/Start
onready var btnOptions = $VBoxContainer/HContainer/PanelLinks/CenterContainer/VBoxContainer/Start
onready var btnQuit = $VBoxContainer/HContainer/PanelLinks/CenterContainer/VBoxContainer/Start
export(PackedScene) var options_scene
var state = GameData.gamestate

func _ready():
	get_tree().paused = true
	if state == GameData.GameState.INGAME:
		btnStart.text = "Resume"
	else:
		btnStart.text = "Start"
	

func _process(_delta):
	if btnStart.get_focus_owner() == null:
		btnStart.grab_focus()


func _on_Options_pressed():
#	GameData.effects_menu_press.play()
	var options = options_scene.instance()
	get_tree().current_scene.add_child(options)


func _on_Start_pressed():
	if state == GameData.GameState.INIT:
		get_parent().start_game()
	elif state == GameData.GameState.INGAME:
		get_tree().paused = false	
#	GameData.effects_menu_press.play()
	queue_free()


func _on_Quit_pressed():
	if state == GameData.GameState.INGAME:
		queue_free()
	elif state == GameData.GameState.INIT:
		get_tree().quit()
