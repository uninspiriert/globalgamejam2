extends KinematicBody2D

export var speed: float = 10.0

onready var anim: AnimationPlayer = $AnimationPlayer

func _ready():
	anim.current_animation = "weapon_idle"
	anim.play()


func _process(_delta: float):
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

	velocity = move_and_slide(velocity.normalized() * speed)

func on_bonk():
	print("bonk")

func _on_AnimationPlayer_animation_finished(anim_name: String):
	if anim_name == "weapon_swipe":
		anim.current_animation = "weapon_idle"


func on_bong():
	pass # Replace with function body.
