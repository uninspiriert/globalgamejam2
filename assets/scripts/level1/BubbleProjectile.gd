extends Area2D

export var speed: float = 100.0

var direction

func init(dir: Vector2):
	direction = dir.normalized()
	return self

func _process(delta):
	self.position += direction * delta * speed


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_BubbleProjectile_body_entered(body: Node):
	if body.is_in_group("player"):
		body.receive_damage()
		queue_free()


func _on_Timer_timeout():
	queue_free()
