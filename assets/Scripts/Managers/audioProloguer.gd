extends AudioStreamPlayer

func _ready():
	set_process(true)

func _process(delta):
	yield(get_tree().create_timer(3.0), "timeout")
	if not is_playing():
		play()
	
