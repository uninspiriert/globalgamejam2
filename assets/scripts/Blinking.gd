extends Node


export(Color) var color = Color.red
export(float) var interval = 0.2
export(int) var blink_times = 3

onready var timer: Timer = $Timer

signal blink
signal blink_over

var blinked = 0

func _ready():
	timer.wait_time = interval

func start():
	timer.start()

func _on_Timer_timeout():
	if blinked < blink_times * 2:
		timer.start()
		if blinked % 2 == 0:
			emit_signal("blink", color)
		else:
			emit_signal("blink", Color.white)
		blinked += 1
	else:
		timer.stop()
		blinked = 0
		emit_signal("blink_over")
