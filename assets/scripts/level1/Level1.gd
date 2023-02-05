extends Node2D

export(PackedScene) var level2_scene

func _process(_delta):
	if get_tree().get_nodes_in_group("teeth").size() == 0:
		switch_scene()

func _input(event):
	if event.is_action("ui_select"):
		switch_scene()
		
func switch_scene():
	var level2 = level2_scene.instance()
	get_parent().add_child(level2)
	GameData.rem_life = $Player.health
	queue_free()
