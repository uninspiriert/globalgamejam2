extends KinematicBody2D

export var speed: float = 10.0
export var health: float = 3.0
export var dashcd: float = 2

onready var anim: AnimationPlayer = $AnimationPlayer
onready var cane_hit_area = $CaneHitArea
onready var canvasUI = get_parent().get_node("CanvasLayer/UI")

func _ready():
	canvasUI.max_dash_cd = dashcd
	canvasUI.on_player_life_changed(health)
	anim.current_animation = "weapon_idle"
	var _tickDashCD = $DashCD.connect("timeout",self,"progress_tick")
	anim.play()
	
func progress_tick():
	canvasUI.on_dashCD_changed(1)

func apply_damage():
	var tooth = null
	var max_z = 0
	for body in cane_hit_area.get_overlapping_bodies():
		if body.is_in_group("teeth") and body.z_index >= max_z:
			max_z = body.z_index
			tooth = body
	if tooth != null:
		tooth.increase_damage()

func _process(_delta: float):
	if Input.is_action_just_pressed("attack"):
		anim.current_animation = "weapon_swipe"
	if Input.is_action_just_pressed("dodge"):
		canvasUI.reset_dashCD()
		$DashCD.start()
		print("dodge")

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

	velocity = move_and_slide(velocity.normalized() * speed)

func on_bonk():
	apply_damage()

func _on_AnimationPlayer_animation_finished(anim_name: String):
	if anim_name == "weapon_swipe":
		anim.current_animation = "weapon_idle"

func receive_damage():
	health -= 1.0
	canvasUI.on_player_life_changed(health)
	if health <= 0.0:
		var _gameover = get_tree().change_scene("res://assets/scenes/GameOver.tscn")
