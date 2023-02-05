extends CanvasLayer

var tname
var score
var savefile: File
var savepath = "user://Score.json"
var customfont
var total_time_seconds

func _ready():

	customfont = DynamicFont.new()
	customfont.font_data = load("res://resources/Oranienbaum-Regular.ttf")
	customfont.size = 48
	_loadHighScore(null)
	tname = $VBoxContainer/HBoxContainer2/HighscorePanel/HighscoreMarginContainer/HighScoreVBoxContainer/NameContainer/tname
	total_time_seconds = OS.get_unix_time() - GameData.start_time
	set_highscore(float(GameData.rem_life) * 10000.0 / total_time_seconds)
	

func _process(_delta):
	if tname.get_focus_owner() == null and tname.focus_mode == 2:
		tname.grab_focus()
	elif tname.get_focus_owner() == null:
		var menu = $VBoxContainer/HBoxContainer/Menu
		menu.grab_focus()
		
func set_highscore(highscore):
	highscore = int(highscore)
	score = highscore
	var LHighscore = $VBoxContainer/HBoxContainer2/HighscorePanel/HighscoreMarginContainer/HighScoreVBoxContainer/HBoxContainer/HighscoreValue
	LHighscore.text = str(highscore*GameData.rem_life)
	
	var stats_time = $VBoxContainer/HBoxContainer2/StatsPanel/StatsMarginContainer/StatsVBoxContainer/StatsPanel/StatsMarginContainer/StatsGridContainer/LTimeScoreVal
	stats_time.text = str(total_time_seconds)
	
	var stats_lifes = $VBoxContainer/HBoxContainer2/StatsPanel/StatsMarginContainer/StatsVBoxContainer/StatsPanel/StatsMarginContainer/StatsGridContainer/LLifeScoreVal
	stats_lifes.text = str(GameData.rem_life)

func _on_Menu_pressed():
	var _main = get_tree().change_scene("res://assets/scenes/Main.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_PostScore_pressed():
	var savebutton = $VBoxContainer/HBoxContainer2/HighscorePanel/HighscoreMarginContainer/HighScoreVBoxContainer/NameContainer/PostScore
	savebutton.text = "Posted"
	tname.editable = false
	tname.focus_mode = false
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
	if not openFile.file_exists(savepath):
		$NoHighscore.visible = true
	else:
		$NoHighscore.visible = false
		var _openfile = openFile.open(savepath, File.READ)
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
	savefile = File.new()
	var scoreData: Dictionary ={
			"name": tname.text,
			"score": score,
			"date": OS.get_datetime()
		}
	if savefile.file_exists(savepath):
		var _savefile = savefile.open(savepath, File.READ_WRITE)
		savefile.seek_end()
	else:
		var _savefile = savefile.open(savepath, File.WRITE)
	savefile.store_line(to_json(scoreData))
	savefile.close()
	_loadHighScore(scoreData)
