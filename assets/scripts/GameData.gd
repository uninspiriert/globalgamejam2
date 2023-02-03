extends Node

export var audio_bus_master := "Master"
onready var _masterbus := AudioServer.get_bus_index(audio_bus_master)

export var audio_bus_music := "Music"
onready var _musicbus := AudioServer.get_bus_index(audio_bus_music)

export var audio_bus_effects := "Effects"
onready var _effectsbus := AudioServer.get_bus_index(audio_bus_effects)

enum GameState {
	INIT,
	INGAME,
	GAMEOVER
	}
	
var gamestate
