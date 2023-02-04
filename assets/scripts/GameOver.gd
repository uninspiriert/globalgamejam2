extends CanvasLayer

onready var restart = load("res://assets/scenes/Main.tscn")
onready var btnBack = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Back
#onready var btnQuit = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Quit

func _ready():
	btnBack.grab_focus()
	GameData.gamestate = GameData.GameState.GAMEOVER
	get_tree().paused = true
	#Dafür muss GameOver direktes Child von Main sein
#	var _switch_music = connect("ready",get_parent(),"set_music")
	
func _on_Back_pressed():
	var _restart = get_tree().change_scene_to(restart)

func _on_Quit_pressed():
	get_tree().quit()
