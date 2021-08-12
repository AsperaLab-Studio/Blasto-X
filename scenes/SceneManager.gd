extends Node


onready var camera : Camera2D = get_parent().get_node("Player/Camera2D")

export(int) var starting_stage := 0

var positions : Array = []


func _ready() -> void:
	var positions : Array = $Positions.get_children()
	
	_select_stage(starting_stage)
	
	
func _select_stage(number):
	camera.limit_left = (positions[number] as Position2D).global_position.x
	camera.limit_right = (positions[number + 1] as Position2D).global_position.x
	
