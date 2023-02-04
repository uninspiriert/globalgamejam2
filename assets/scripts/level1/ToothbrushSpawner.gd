extends Node2D


export(PackedScene) var toothbrush_scene;
export(Texture) var warning_texture
export(int) var side_num_segments = 3
export(int) var bottom_num_segments = 4

var rng = RandomNumberGenerator.new()
var toothbrush = null
onready var warn_sprite = Sprite.new()

const LEFT = 0
const RIGHT = 1
const BOTTOM = 2

const WARN_WIDTH = 20
const WARN_TIME_SECS = 1.0

func _ready():
	rng.randomize()
	warn_sprite.set_texture(warning_texture)
	get_parent().call_deferred("add_child", warn_sprite)
	toothbrush = toothbrush_scene.instance()
	add_child(toothbrush)

func brush():
	var w = get_viewport_rect().size.x
	var h = get_viewport_rect().size.y

	var side = rng.randi_range(0, 2)
	var num_segments = side_num_segments
	var length = h
	if side == BOTTOM:
		num_segments = bottom_num_segments
		length = w

	var segment = rng.randi_range(0, num_segments - 1)

	var player_pos = get_parent().get_node("Player").global_position
	var player_pos2 = player_pos / Vector2(w / bottom_num_segments, h / side_num_segments)
	player_pos2.x = int(player_pos2.x)
	player_pos2.y = int(player_pos2.y)

	# in 2/3 of cases use the player pos instead of random
	if rng.randi_range(0, 2) != 0:
		if side == BOTTOM:
			segment = player_pos2.x
		else:
			segment = player_pos2.y

	var warn_len = length / num_segments
	var warn_offset = segment * warn_len + warn_len * 0.5

	match side:
		LEFT:
			var warn_rect = Rect2(0.5 * WARN_WIDTH, warn_offset, WARN_WIDTH, warn_len)
			show_warning(warn_rect)
			rotation_degrees = 90
			global_position = warn_rect.position
			yield(get_tree().create_timer(WARN_TIME_SECS), "timeout")
			toothbrush.brush_sides()
		RIGHT:
			var warn_rect = Rect2(get_viewport_rect().size.x - 0.5 * WARN_WIDTH, warn_offset, WARN_WIDTH, warn_len)
			show_warning(warn_rect)
			rotation_degrees = -90
			global_position = warn_rect.position
			yield(get_tree().create_timer(WARN_TIME_SECS), "timeout")
			toothbrush.brush_sides()
		BOTTOM:
			var warn_rect = Rect2(warn_offset, get_viewport_rect().size.y - 0.5 * WARN_WIDTH, warn_len, WARN_WIDTH)
			show_warning(warn_rect)
			rotation_degrees = 0
			global_position = warn_rect.position
			yield(get_tree().create_timer(WARN_TIME_SECS), "timeout")
			toothbrush.brush_bottom()

func show_warning(rect: Rect2):
	warn_sprite.global_position = rect.position
	warn_sprite.global_scale = rect.size / warning_texture.get_size()
