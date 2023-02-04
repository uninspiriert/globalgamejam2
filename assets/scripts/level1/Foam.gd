extends Node2D

export(PackedScene) var bubble

onready var particles = $Particles2D

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func _physics_process(_delta: float):
	if not particles.is_emitting():
		print("free")
		queue_free()
		return

	if rng.randi_range(1, 200) == 1:
		print("shoot")
