tool
extends StaticBody2D

export(PackedScene) var blood_splatter;
export(Array, Texture) var damage_levels = []

onready var sprite = $Sprite
onready var timer = $RepairTimer

var damage_level = 0

func _ready():
	set_correct_texture()

func set_correct_texture():
	sprite.set_texture(damage_levels[damage_level])

func increase_damage() -> bool:
	$BonkPlayer.play()

	if damage_level == damage_levels.size() - 1:
		var blood = blood_splatter.instance()
		blood.position = position
		blood.scale = scale
		blood.z_index = z_index
		get_parent().add_child(blood)
		queue_free()
		return true

	damage_level += 1
	timer.start()
	set_correct_texture()
	return false

func decrease_damage():
	damage_level = max(0, damage_level - 1)
	set_correct_texture()
	if damage_level > 0:
		timer.start()
