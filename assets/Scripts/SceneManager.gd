extends Node

export var increment = 1566
export var y = 768
export var n_positions = 5
export(Array, PackedScene) var enemy_types

onready var camera : Camera2D = get_parent().get_node("Player/Camera2D")
onready var wall: StaticBody2D = $MovingWall
onready var game_over: Sprite = get_parent().get_node("GUI/UI2/GAME OVER")
onready var AreaGo: Area2D = $MovingWall/AreaGo
onready var player = get_parent().get_node("Player")
onready var go = get_parent().get_node("GUI/UI2/Go")

export(int) var current_stage := 0

var spawned = false
var positions : Array = []
var spawnList: Array = []

func _ready() -> void:
	positions = $Positions.get_children()
	_select_stage(current_stage)
	
	randomize()
	
	#player.connect("death", self, "_on_Player_death")
	

func _process(delta: float) -> void:
	
	if player.global_position.x > wall.global_position.x - 750 && spawned == false:
		_enemy_spawn(current_stage)
	
	if $EnemiesContainer.get_child_count() == 0 && spawned == true:
		go.visible = true
		
	
	if player.collision_shape.disabled == true:
		game_over.visible = true
		
	
	if Input.is_action_pressed("ui_accept"):
		get_tree().paused = true
		get_tree().change_scene("res://scenes/levels/LevelDesert1.tscn")
	

func _select_stage(number):
	#camera.limit_left = (positions[number] as Position2D).global_position.x
	camera.limit_right = (positions[number + 1] as Position2D).global_position.x
	
	wall.global_position = (positions[number + 1] as Position2D).global_position
	

func _enemy_spawn(number):
	spawned = true
	var enemyNumber = NodePath((number) as String)
	
	spawnList = $EnemiesSpawn.get_node(enemyNumber).get_children()
	
	for spawn in spawnList:
		var rand_index:int = randi() % enemy_types.size()
		
		var enemy_instance = enemy_types[rand_index].instance()
		$EnemiesContainer.add_child(enemy_instance)
		enemy_instance.global_position = (spawn as Position2D).global_position
		enemy_instance.target = player
		
	

func _on_Player_death() -> void:
	var pausable_members = get_tree().get_nodes_in_group("pausable")
	
	print(pausable_members.size())
	
	for member in pausable_members:
		print(member.name)
		member.pause()
		
	
