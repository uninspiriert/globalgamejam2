extends Node

export var audio_bus_master := "Master"
onready var _masterbus := AudioServer.get_bus_index(audio_bus_master)

export var audio_bus_music := "Music"
onready var _musicbus := AudioServer.get_bus_index(audio_bus_music)

export var audio_bus_effects := "Effects"
onready var _effectsbus := AudioServer.get_bus_index(audio_bus_effects)

var start_time
var end_time
var rem_life

enum GameState {
	INIT,
	INGAME,
	GAMEOVER
	}
	
var gamestate
