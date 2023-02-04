tool
extends StaticBody2D

export(Array, Texture) var damage_levels = []

onready var sprite = $Sprite
onready var timer = $RepairTimer

var damage_level = 0

func _ready():
	set_correct_texture()

func set_correct_texture():
	sprite.set_texture(damage_levels[damage_level])

func increase_damage():
	if damage_level == damage_levels.size() - 1:
		queue_free()
		return

	damage_level += 1
	timer.start()
	set_correct_texture()

func decrease_damage():
	damage_level = max(0, damage_level - 1)
	set_correct_texture()
	if damage_level > 0:
		timer.start()
