extends Node2D


export(PackedScene) var toothbrush_scene;
export(Texture) var warning_texture
export(int) var side_num_segments = 3
export(int) var bottom_num_segments = 4
export(float) var wait_time_addition = 0.5

var rng = RandomNumberGenerator.new()
var toothbrush = null
onready var warn_sprite = Sprite.new()
onready var spawn_timer = $Timer

const LEFT = 0
const RIGHT = 1
const BOTTOM = 2

const WARN_WIDTH = 40
const MIN_WARN_TIME = 0.2
const MAX_WARN_TIME = 1.0
# const MIN_WAIT_TIME = 0.4

var num_teeth_initial = 16.0
var num_teeth = num_teeth_initial
var warn_time_secs = 1.0

var warn_time_interval = MAX_WARN_TIME / num_teeth
var anime_length

func _ready():
	rng.randomize()
	warn_sprite.set_texture(warning_texture)
	warn_sprite.visible = false
	get_parent().call_deferred("add_child", warn_sprite)
	toothbrush = toothbrush_scene.instance()
	add_child(toothbrush)
	var anime_player = toothbrush.get_node("AnimationPlayer")
	var anime_bottom = anime_player.get_animation("brush_bottom")
	var anime_side = anime_player.get_animation("brush_sides")
	anime_length = max(anime_bottom.get_length(), anime_side.get_length())

func adjust_timers():
	num_teeth -= 1
	var steps = float(num_teeth_initial - num_teeth) / num_teeth_initial
	warn_time_secs = lerp(MAX_WARN_TIME, MIN_WARN_TIME, ease(steps, 3))
	spawn_timer.wait_time = anime_length + warn_time_secs + wait_time_addition

func brush():
	spawn_timer.stop()
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

	# in 1/2 of cases use the player pos instead of random
	if rng.randi_range(0, 1) != 0:
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
			wait_then_brush("brush_sides")
		RIGHT:
			var warn_rect = Rect2(get_viewport_rect().size.x - 0.5 * WARN_WIDTH, warn_offset, WARN_WIDTH, warn_len)
			show_warning(warn_rect)
			rotation_degrees = -90
			global_position = warn_rect.position
			wait_then_brush("brush_sides")
		BOTTOM:
			var warn_rect = Rect2(warn_offset, get_viewport_rect().size.y - 0.5 * WARN_WIDTH, warn_len, WARN_WIDTH)
			show_warning(warn_rect)
			rotation_degrees = 0
			global_position = warn_rect.position
			wait_then_brush("brush_bottom")

func wait_then_brush(brush_type: String):
	var timer = Timer.new()
	timer.set_one_shot(true)
	timer.connect("timeout", self, "do_the_brushing", [timer, brush_type])
	add_child(timer)
	timer.start(warn_time_secs)

func do_the_brushing(timer, brush_type):
	toothbrush.call(brush_type)
	timer.stop()
	remove_child(timer)
	spawn_timer.start()

func show_warning(rect: Rect2):
	warn_sprite.global_position = rect.position
	warn_sprite.global_scale = rect.size / warning_texture.get_size()
	warn_sprite.visible = true
