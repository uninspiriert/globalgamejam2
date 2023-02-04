extends CanvasLayer

func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("attack"):
		get_node("A-Button").scale = Vector2(3,3)
	if event.is_action_released("attack"):
		get_node("A-Button").scale = Vector2(4,4)

	if event.is_action_pressed("dodge"):
		get_node("B-Button").scale = Vector2(3,3)
	if event.is_action_released("dodge"):
		get_node("B-Button").scale = Vector2(4,4)
