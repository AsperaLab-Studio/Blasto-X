extends VideoPlayer

export var next_scene = ""
export var to_mainMenu = false
var pid = null;

func _ready(): #{
	pass
#}

func _process(delta: float) -> void:
	if Input.is_action_pressed("skip"):
		if to_mainMenu == false:
			get_tree().change_scene("res://scenes/levels/" + next_scene + ".tscn")
			
		else:
			get_tree().change_scene("res://scenes/misc/MainMenu.tscn")
			
		
	

func _on_VideoPlayer_finished() -> void:
	if to_mainMenu == false:
		get_tree().change_scene("res://scenes/levels/" + next_scene + ".tscn")
	else:
		get_tree().change_scene("res://scenes/misc/MainMenu.tscn")
