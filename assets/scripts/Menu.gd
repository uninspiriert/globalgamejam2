extends CanvasLayer

onready var btnStart = 		$VBoxContainer/HContainer/PanelLinks/CenterContainer/VBoxContainer/Start
onready var btnOptions = 	$VBoxContainer/HContainer/PanelLinks/CenterContainer/VBoxContainer/Options
onready var btnQuit = 		$VBoxContainer/HContainer/PanelLinks/CenterContainer/VBoxContainer/Quit
onready var restart = load("res://assets/scenes/Main.tscn")
onready var icon_selection = load("res://assets/sprites/tooth-top.png")
export(PackedScene) var options_scene
var state = GameData.gamestate

func _ready():
	var _switch_music = connect("ready",get_parent(),"set_music")
	get_tree().paused = true
	if state == GameData.GameState.INGAME:
		btnStart.text = "Resume"
	else:
		btnStart.text = "Start"
	

func _process(_delta):
	if btnStart.get_focus_owner() == null:
		btnStart.grab_focus()

func _on_Start_pressed():
	if state == GameData.GameState.INIT:
		get_parent().start_game()
	elif state == GameData.GameState.INGAME:
		get_tree().paused = false
		emit_signal("ready")
#	GameData.effects_menu_press.play()
	queue_free()

func _on_Options_pressed():
#	GameData.effects_menu_press.play()
	var options = options_scene.instance()
	get_tree().current_scene.add_child(options)

func _on_Quit_pressed():
	if state == GameData.GameState.INGAME:
		queue_free()
		var _restart = get_tree().change_scene_to(restart)
	elif state == GameData.GameState.INIT:
		get_tree().quit()

#func _on_Start_focus_entered():
#	btnStart.icon = icon_selection
#
#func _on_Start_focus_exited():
#	btnStart.icon = null
#
#func _on_Options_focus_entered():
#	btnOptions.icon = icon_selection
#
#func _on_Options_focus_exited():
#	btnOptions.icon = null
#
#func _on_Quit_focus_entered():
#	btnQuit.icon = icon_selection
#
#func _on_Quit_focus_exited():
#	btnQuit.icon = null
