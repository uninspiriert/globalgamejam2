extends Node2D

onready var anim: AnimationPlayer = $AnimationPlayer

func _ready():
	pass # Replace with function body.


func _process(_delta: float):
	if Input.is_action_just_pressed("attack"):
		print("attack")
		anim.current_animation = "swipe"
		anim.play()
	if Input.is_action_pressed("attack"):
		print("other attack")
