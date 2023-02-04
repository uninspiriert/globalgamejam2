extends Control

var heart_size: int = 64

func on_player_life_changed(player_hearts: float):
	$Hearts.rect_size.x = player_hearts * heart_size
