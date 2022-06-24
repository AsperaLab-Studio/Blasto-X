extends VideoPlayer

var pid = null;

func _ready(): #{
	var videopath = "res://assets/video/Blasto_3.mp4"
	pid = OS.execute("res://assets/Scripts/ffplay",["-autoexit", "-exitonkeydown", "-exitonmousedown", "-fs", videopath ],true); 
	pass
#}

func _on_VideoPlayer_finished() -> void:
	get_tree().change_scene("res://scenes/LevelDesert1.tscn")
