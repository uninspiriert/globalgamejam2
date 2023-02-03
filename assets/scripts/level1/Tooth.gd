extends StaticBody2D

export(Array, Texture) var damage_levels = []

onready var sprite = $Sprite

var damage_level = 0

func increase_damage():
	sprite.set_texture(damage_levels[damage_level])
	damage_level = min(damage_level + 1, damage_levels.size() - 1)
