extends Node


onready var camera : Camera2D = get_parent().get_node("Player/Camera2D")
onready var wall: StaticBody2D = $MovingWall
onready var player = get_parent().get_node("Player")

export(int) var starting_stage := 0

var positions : Array = []
var enemy = preload("res://scenes/Enemy.tscn")


func _ready() -> void:
	positions = $Positions.get_children()
	
	_select_stage(starting_stage)
	

func _select_stage(number):
	camera.limit_left = (positions[number] as Position2D).global_position.x
	camera.limit_right = (positions[number + 1] as Position2D).global_position.x
	
	wall.global_position = (positions[number + 1] as Position2D).global_position
	
	var enemyNumber = NodePath((number + 1) as String)
	
	var spawnList: Array = $EnemiesSpawn.get_node(enemyNumber).get_children()
	
	for spawn in spawnList:
		var enemy_instance = enemy.instance()
		$EnemiesContainer.add_child(enemy_instance)
		enemy_instance.global_position = (spawn as Position2D).global_position
		enemy_instance.target = player
	
