extends AudioStreamPlayer

var ost = preload("res://assets/audio/ost/lvl 1-d loop.ogg")

func _ready(): 
	set_process(true)

func _process(delta):
	if not is_playing():
		stream = ost
		play()
	

func pause():
	set_process(false)
	stop()
	
