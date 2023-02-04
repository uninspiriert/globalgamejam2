extends Node2D

export(PackedScene) var menu_scene
export(PackedScene) var level1_scene

func _ready():
	get_tree().paused = false
	init()

func init():
	GameData.gamestate = GameData.GameState.INIT
	var menu = menu_scene.instance()
	add_child(menu)

func start_game():
	$Gamemusic.play()
	GameData.gamestate = GameData.GameState.INGAME
	var level1 = level1_scene.instance()
	add_child(level1)
	get_tree().paused = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused == false and GameData.gamestate == GameData.GameState.INGAME:
			var menu = menu_scene.instance()
			add_child(menu)
