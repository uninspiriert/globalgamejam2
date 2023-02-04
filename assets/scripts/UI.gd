extends Control

var heart_size: int = 64
var max_dash_cd: float = 2

func _ready():
	$DashCD.max_value = max_dash_cd*100

func on_player_life_changed(player_hearts: float):
	$Hearts.rect_size.x = player_hearts * heart_size
	
func on_dashCD_changed(cd: float):
	$DashCD.value += cd
	
func reset_dashCD():
	$DashCD.value = 0
