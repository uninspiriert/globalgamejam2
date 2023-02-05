extends CanvasLayer

export(PackedScene) var options_scene
#onready var TName = $VBoxContainer/HBoxContainer2/HighscorePanel/HighscoreMarginContainer/HighScoreVBoxContainer/NameContainer/TName
var TName
var score
var saveFile: File
var savePath = "user://Score.json"
var customfont

func _ready():
	customfont = DynamicFont.new()
	customfont.font_data = load("res://Font/Xolonium-Regular.ttf")
	customfont.size = 20
	_loadHighScore(null)
	TName = $VBoxContainer/HBoxContainer2/HighscorePanel/HighscoreMarginContainer/HighScoreVBoxContainer/NameContainer/TName


func _process(_delta):
	if TName.get_focus_owner() == null and TName.focus_mode == 2:
		TName.grab_focus()
	elif TName.get_focus_owner() == null:
		var menu = $VBoxContainer/HBoxContainer/Menu
		menu.grab_focus()
		
func set_highscore(highscore):
	score = highscore
	var LHighscore = $VBoxContainer/HBoxContainer2/HighscorePanel/HighscoreMarginContainer/HighScoreVBoxContainer/HBoxContainer/HighscoreValue
	LHighscore.text = str(highscore)
	
	var statskilled = $VBoxContainer/HBoxContainer2/StatsPanel/StatsMarginContainer/StatsVBoxContainer/StatsPanel/StatsMarginContainer/StatsGridContainer/LEnemyScoreVal
	statskilled.text = str(highscore)

func _on_Menu_pressed():
	GameData.effects_menu_press.play()
	var _main = get_tree().change_scene("res://Scenes/Main.tscn")


func _on_Options_pressed():
	GameData.effects_menu_press.play()
	var options = options_scene.instance()
	get_tree().current_scene.add_child(options)
	hide()


func _on_Quit_pressed():
	GameData.effects_menu_press.play()
	get_tree().quit()


func _on_PostScore_pressed():
	GameData.effects_menu_press.play()
	var savebutton = $VBoxContainer/HBoxContainer2/HighscorePanel/HighscoreMarginContainer/HighScoreVBoxContainer/NameContainer/PostScore
	savebutton.text = "Posted"
	TName.editable = false
	TName.focus_mode = false
	savebutton.disabled = true
	savebutton.focus_mode = false
	_saveHighScore()

func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func _loadHighScore(scoreData):
	var containerNames = $VBoxContainer/HBoxContainer2/HighscorePanel/HighscoreMarginContainer/HighScoreVBoxContainer/StatsPanel/ScrollContainer/StatsMarginContainer/HBoxStatsContainer/StatsGridContainer/VContainerNames
	var containerScores = $VBoxContainer/HBoxContainer2/HighscorePanel/HighscoreMarginContainer/HighScoreVBoxContainer/StatsPanel/ScrollContainer/StatsMarginContainer/HBoxStatsContainer/StatsGridContainer/VContainerScores
	delete_children(containerNames)
	delete_children(containerScores)
	var openFile: File = File.new()
	if not openFile.file_exists(savePath):
		$NoHighscore.visible = true
	else:
		$NoHighscore.visible = false
		var _openfile = openFile.open(savePath, File.READ)
		var dataArray: Array = []
		
		while openFile.get_position() < openFile.get_len():
			var data: Dictionary = parse_json(openFile.get_line())
			dataArray.append(data)
			
		openFile.close()
		dataArray.sort_custom(self,"_customSort")
		
		for data in dataArray:
			var newname = Label.new()
			newname.text = data.name
			newname.add_font_override("font",customfont)
			containerNames.add_child(newname)
			
			var newscore = Label.new()
			newscore.text = str(data.score)
			newscore.add_font_override("font",customfont)			
			containerScores.add_child(newscore)
			if scoreData == data:
				newname.grab_focus()


func _customSort(a,b):
	if a["score"] > b["score"]:
		return true
	return false


func _saveHighScore():
	saveFile = File.new()
	var scoreData: Dictionary ={
			"name": TName.text,
			"score": score,
			"date": OS.get_datetime()
		}
	if saveFile.file_exists(savePath):
		var _savefile = saveFile.open(savePath, File.READ_WRITE)
		saveFile.seek_end()
	else:
		var _savefile = saveFile.open(savePath, File.WRITE)
	saveFile.store_line(to_json(scoreData))
	saveFile.close()
	_loadHighScore(scoreData)
