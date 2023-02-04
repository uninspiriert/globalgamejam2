extends Area2D

export(Texture) var warning_texture
export(int) var side_num_segments = 3
export(int) var bottom_num_segments = 4

var rng = RandomNumberGenerator.new()
onready var warn_sprite = Sprite.new()
onready var anim = $AnimationPlayer
onready var brush_sprite = $Sprite

const LEFT = 0
const RIGHT = 1
const BOTTOM = 2

const WARN_WIDTH = 20
const WARN_TIME_SECS = 1.0

func _ready():
	rng.randomize()
	warn_sprite.set_texture(warning_texture)
	get_parent().call_deferred("add_child", warn_sprite)
	brush_sprite.visible = false

func brush():
	var side = rng.randi_range(0, 2)
	var num_segments = side_num_segments
	var length = get_viewport_rect().size.y
	if side == BOTTOM:
		num_segments = bottom_num_segments
		length = get_viewport_rect().size.x

	var segment = rng.randi_range(0, num_segments - 1)
	var warn_len = length / num_segments
	var warn_offset = segment * warn_len + warn_len * 0.5

	match side:
		LEFT:
			var warn_rect = Rect2(0.5 * WARN_WIDTH, warn_offset, WARN_WIDTH, warn_len)
			global_position = warn_rect.position
			rotation_degrees = 90
			show_warning(warn_rect)
			yield(get_tree().create_timer(WARN_TIME_SECS), "timeout")
			brush_sprite.visible = true
			anim.current_animation = "brush"
			anim.play()
			# brush_sprite.visible = false
		RIGHT:
			show_warning(Rect2(get_viewport_rect().size.x - 0.5 * WARN_WIDTH, warn_offset, WARN_WIDTH, warn_len))
			yield(get_tree().create_timer(WARN_TIME_SECS), "timeout")
			print("brush")
		BOTTOM:
			show_warning(Rect2(warn_offset, get_viewport_rect().size.y - 0.5 * WARN_WIDTH, warn_len, WARN_WIDTH))
			yield(get_tree().create_timer(WARN_TIME_SECS), "timeout")
			print("brush")

func show_warning(rect: Rect2):
	warn_sprite.global_position = rect.position
	warn_sprite.global_scale = rect.size / warning_texture.get_size()
