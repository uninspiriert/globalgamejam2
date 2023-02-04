extends KinematicBody2D

export var speed: float = 10.0
export var dash_speed: float = 1
export var health: float = 3.0


enum PlayerState{
	NONE,
	IMMOBILIZED
}
var playerState

onready var anim: AnimationPlayer = $AnimationPlayer
onready var cane_hit_area = $CaneHitArea
onready var canvasUI = get_parent().get_node("CanvasLayer/UI")
var screen_size

func _ready():
	playerState = PlayerState.NONE
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
		tooth.increase_damage()

func _process(delta: float):
	$DashCD.tick(delta)
	if Input.is_action_just_pressed("attack"):
		anim.current_animation = "weapon_swipe"

func _physics_process(_delta: float):
	var velocity = Vector2.ZERO
#
#	if playerState != PlayerState.IMMOBILIZED:
	if Input.is_action_just_pressed("dodge") and $DashCD.is_ready():
		$DashDuration.start()
		dash_speed = 5
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1

	
	velocity = move_and_slide(velocity.normalized() * speed * dash_speed)
		
		
	if velocity.x != 0:
		$AnimatedSprite.flip_h = velocity.x < 0
		$Sugarcane/Sprite.flip_h = velocity.x < 0
		
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func on_bonk():
	apply_damage()

func _on_AnimationPlayer_animation_finished(anim_name: String):
	if anim_name == "weapon_swipe":
		anim.current_animation = "weapon_idle"

func receive_damage():
	if dash_speed == 1:
		health -= 1.0
		canvasUI.on_player_life_changed(health)
		if health <= 0.0:
			var _gameover = get_tree().change_scene("res://assets/scenes/GameOver.tscn")

func _on_DashDuration_timeout():
	dash_speed = 1

func _on_Immobilized_timeout():
	playerState = PlayerState.NONE
