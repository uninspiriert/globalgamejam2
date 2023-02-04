extends CanvasLayer

onready var btnStart = $VBoxContainer/HContainer/PanelLinks/CenterContainer/VBoxContainer/Start
onready var btnOptions = $VBoxContainer/HContainer/PanelLinks/CenterContainer/VBoxContainer/Start
onready var btnQuit = $VBoxContainer/HContainer/PanelLinks/CenterContainer/VBoxContainer/Start
var state = GameData.gamestate

func _ready():
	if state == GameData.GameState.INGAME:
		get_tree().paused = true
		btnStart.text = "Resume"

func _process(_delta):
	if btnStart.get_focus_owner() == null:
		btnStart.grab_focus()
