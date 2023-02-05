extends Node2D

onready var particles = $Particles2D

func _ready():
	particles.emitting = true
	$SplattSounds.play()

func _physics_process(_delta: float):
	if not particles.is_emitting():
		queue_free()
		return
