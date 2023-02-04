extends CanvasLayer

var mastervolume = db2linear(AudioServer.get_bus_volume_db(GameData._masterbus))
var musicvolume = db2linear(AudioServer.get_bus_volume_db(GameData._musicbus))
var effectsvolume = db2linear(AudioServer.get_bus_volume_db(GameData._effectsbus))

onready var sliderMaster = $VContainer/Panel/GridContainer/ContainerMasterSlider/SliderMaster
onready var sliderMusic = $VContainer/Panel/GridContainer/ContainerMusicSlider/SliderMusic
onready var sliderEffects = $VContainer/Panel/GridContainer/ContainerEffectsSlider/SliderEffects
onready var labelMaster = $VContainer/Panel/GridContainer/ValMaster
onready var labelMusic = $VContainer/Panel/GridContainer/ValMusic
onready var labelEffects = $VContainer/Panel/GridContainer/ValEffects


func _ready():
	sliderMaster.grab_focus()
	sliderMaster.value = mastervolume
	sliderMusic.value = musicvolume
	sliderEffects.value = effectsvolume
	labelMaster.text = str(round(mastervolume*100)) + "%"
	labelMusic.text = str(round(musicvolume*100)) + "%"
	labelEffects.text = str(round(effectsvolume*100)) + "%"

func _on_SliderMaster_value_changed(value):
	AudioServer.set_bus_volume_db(GameData._masterbus, linear2db(value))
	labelMaster.text = str(value*100) + "%"


func _on_SliderMusic_value_changed(value):
	AudioServer.set_bus_volume_db(GameData._masterbus, linear2db(value))
	labelMusic.text = str(value*100) + "%"


func _on_SliderEffects_value_changed(value):
	AudioServer.set_bus_volume_db(GameData._masterbus, linear2db(value))
	labelEffects.text = str(value*100) + "%"


func _on_Back_pressed():
	queue_free()
