extends VideoPlayer

var pid = null;

func _ready(): #{
	pass
#}

func _process(delta: float) -> void:
	if Input.is_action_pressed("skip"):
		get_tree().change_scene("res://scenes/levels/LevelDesert1.tscn")

func _on_VideoPlayer_finished() -> void:
	get_tree().change_scene("res://scenes/levels/LevelDesert1.tscn")
