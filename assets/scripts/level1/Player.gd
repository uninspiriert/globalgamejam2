extends KinematicBody2D

export var speed: float = 10.0
export var dash_speed: float = 1
export var health: float = 4.0
export(PackedScene) var poof_scene

enum PlayerState{
	NONE,
	IMMOBILIZED,
	INVINCIBLE
}
var player_state

onready var anim_sprite = $AnimatedSprite
onready var anim: AnimationPlayer = $AnimationPlayer
onready var cane_hit_area = $CaneHitArea
onready var canvasUI = get_parent().get_node("CanvasLayer/UI")
onready var shake = $"../Camera2D/ShakeScreen"
onready var blinker = $Blinking
onready var dash_poof = $DashPoof/Particles2D

var screen_size = null

func _ready():
	player_state = PlayerState.NONE
	screen_size = get_viewport_rect().size
	$DashCD.init(1)
	canvasUI.on_player_life_changed(health)
	anim.current_animation = "weapon_idle"
	anim.play()

func apply_damage():
	var tooth = null
	var max_z = 0
	for body in cane_hit_area.get_overlapping_bodies():
		if body.is_in_group("teeth") and body.z_index >= max_z:
			max_z = body.z_index
			tooth = body
	if tooth != null:
		if tooth.increase_damage():
			shake.start()
		else:
			shake.start(0.1, 15, 8)

func _process(delta: float):
	$DashCD.tick(delta)
	if Input.is_action_just_pressed("attack"):
		anim.current_animation = "weapon_swipe"

func _physics_process(_delta: float):
	var velocity = Vector2.ZERO

	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1

	if Input.is_action_just_pressed("dodge") and $DashCD.is_ready():
		$DashDuration.start()
		dash_speed = 5
		player_state = PlayerState.INVINCIBLE
		if velocity.length() != 0:
			var dash_poof = poof_scene.instance()
			get_parent().add_child(dash_poof)
			dash_poof.global_position = global_position
			dash_poof.look_at(global_position + 100 * velocity)
			dash_poof.global_position = global_position - velocity.normalized()
			dash_poof.scale = scale
			dash_poof.restart()

	
	velocity = move_and_slide(velocity.normalized() * speed * dash_speed)

	if velocity.x != 0:
		$AnimatedSprite.flip_h = velocity.x < 0
		$Sugarcane/Sprite.flip_h = velocity.x < 0

	if velocity.y > 0:
		anim_sprite.animation = "walking_down"
	else:
		anim_sprite.animation = "walking"

	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func on_bonk():
	apply_damage()

func _on_AnimationPlayer_animation_finished(anim_name: String):
	if anim_name == "weapon_swipe":
		anim.current_animation = "weapon_idle"

func receive_damage():
	if player_state == PlayerState.INVINCIBLE:
		return

	blinker.start()
	player_state = PlayerState.INVINCIBLE
	health -= 1.0
	canvasUI.on_player_life_changed(health)
	if health <= 0.0:
		var _gameover = get_tree().change_scene("res://assets/scenes/GameOver.tscn")

func _on_DashDuration_timeout():
	dash_speed = 1
	reset_player_state()

func reset_player_state():
	player_state = PlayerState.NONE

func blink(color):
	self.modulate = color
