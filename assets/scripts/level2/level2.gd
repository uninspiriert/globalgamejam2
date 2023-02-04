extends CanvasLayer

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("attack"):
		get_node("A-Button").scale = Vector2(3,3)
		$AttackProgress.stop()
		$ProgressbarTooth.value += 1
	if event.is_action_released("attack"):
		$AttackProgress.start()
		get_node("A-Button").scale = Vector2(4,4)

	if event.is_action_pressed("dodge"):
		get_node("B-Button").scale = Vector2(3,3)
		$AttackProgress.stop()
		$ProgressbarTooth.value += 1
	if event.is_action_released("dodge"):
		$AttackProgress.start()
		get_node("B-Button").scale = Vector2(4,4)

func _on_AttackProgress_timeout():
	if $ProgressbarTooth.value >= 0:
		$ProgressbarTooth.value -= 1
