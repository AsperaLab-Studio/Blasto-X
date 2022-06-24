extends Node


onready var camera : Camera2D = get_parent().get_node("Player/Camera2D")
onready var wall: StaticBody2D = $MovingWall
onready var AreaGo: Area2D = $MovingWall/AreaGo
onready var player = get_parent().get_node("Player")
onready var go = get_parent().get_node("GUI/UI2/Go")

export(int) var current_stage := 0

var positions : Array = []
var spawnList: Array = []
var enemy = preload("res://scenes/krogan.tscn")


func _ready() -> void:
	positions = $Positions.get_children()
	go.visible = false
	_select_stage(current_stage)
	

func _process(delta: float) -> void:
	if $EnemiesContainer.get_child_count() == 0:
		go.visible = true
	

func _select_stage(number):
	#camera.limit_left = (positions[number] as Position2D).global_position.x
	camera.limit_right = (positions[number + 1] as Position2D).global_position.x
	
	wall.global_position = (positions[number + 1] as Position2D).global_position
	
	var enemyNumber = NodePath((number) as String)
	
	spawnList = $EnemiesSpawn.get_node(enemyNumber).get_children()
	
	for spawn in spawnList:
		var enemy_instance = enemy.instance()
		$EnemiesContainer.add_child(enemy_instance)
		enemy_instance.global_position = (spawn as Position2D).global_position
		enemy_instance.target = player
	
