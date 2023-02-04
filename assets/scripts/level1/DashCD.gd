extends Timer
onready var DashBar = get_parent().get_parent().get_node("CanvasLayer/UI/DashCD")

var time:float = 0.0
var max_time = 0.0

func init(_max_time):
	self.max_time = _max_time
	self.time = 0
	DashBar.max_value = _max_time

func tick(delta: float):
	time = max(time - delta, 0)
	DashBar.value = time

func is_ready():
	if time > 0:
		return false
	time = max_time
	return true
