extends Node

export var increment = 1566
export var y = 768
export var n_positions = 5
export(Array, PackedScene) var scenes

func _ready() -> void:
	randomize()
	for n in n_positions:
		var rand_index:int = randi() % scenes.size()
		print(rand_index)
		var scene_instance = scenes[rand_index].instance()
		scene_instance.position = Vector2(increment * (n + 1), y)
		add_child(scene_instance)
