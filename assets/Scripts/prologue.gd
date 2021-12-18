extends VideoPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_VideoPlayer_finished() -> void:
	get_tree().change_scene("res://scenes/LevelDesert1.tscn")
