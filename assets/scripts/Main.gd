extends Node2D

export(PackedScene) var menu_scene
export(PackedScene) var level1_scene

func _ready():
	init()

func init():
	get_tree().paused = true
	set_music()
	GameData.gamestate = GameData.GameState.INIT
	var menu = menu_scene.instance()
	add_child(menu)

func start_game():
	GameData.gamestate = GameData.GameState.INGAME		 
	var level1 = level1_scene.instance()
	add_child(level1)
	get_tree().paused = false
	set_music()

func _unhandled_input(event):
	if event.is_action_pressed("ui_home"):
		if get_tree().paused == false and GameData.gamestate == GameData.GameState.INGAME:
			var menu = menu_scene.instance()
			add_child(menu)

func set_music():
	if get_tree().paused == false:
		$Gamemusic.play()
		$Titlemusic.stop()
	else:
		$Gamemusic.stop()
		$Titlemusic.play()
