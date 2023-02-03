extends AnimationPlayer

signal bonk_moment_reached

func on_bonk():
	emit_signal("bonk_moment_reached")
