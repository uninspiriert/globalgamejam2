extends Node2D

export(PackedScene) var menu_scene

func _ready():
	var menu = menu_scene.instance()
	add_child(menu)
	pass # Replace with function body.
