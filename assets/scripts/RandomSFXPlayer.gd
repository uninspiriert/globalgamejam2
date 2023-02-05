extends AudioStreamPlayer

export(Array, AudioStream) var audio_files: Array
var audio_files_size: int

func _ready() -> void:
	randomize()
	audio_files_size = audio_files.size() 

func play_random():
  var random_index: = randi() % audio_files.size()
  stop()
  stream = audio_files[random_index]
  play()

