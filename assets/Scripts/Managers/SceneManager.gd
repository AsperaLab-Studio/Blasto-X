extends Node

export var increment = 1566
export var y = 768
export var n_positions = 5
export(Array, PackedScene) var enemy_types
export(int) var current_stage := 0
export var next_stage = ""
export var current_level = ""
export var totalFightPhases = 2

onready var camera : Camera2D = get_parent().get_node("PlayersList/Blasto/Camera2D")
onready var wall: StaticBody2D = $MovingWall
onready var AreaGo: Area2D = $MovingWall/AreaGo
onready var sound = get_parent().get_node("ost")
onready var players = get_parent().get_node("PlayersList").get_children()
onready var go = get_parent().get_node("GUI/UI/Go")
onready var game_over: Sprite = get_parent().get_node("GUI/UI/GAME OVER")
onready var win = get_parent().get_node("GUI/UI/WIN")

onready var ScoreFolder = get_parent().get_node("GUI/UI/Sprite/SCORE")
onready var TotalPoints = get_parent().get_node("GUI/UI/Sprite/SCORE/TotalPoints")
onready var showedPoints = get_parent().get_node("GUI/UI/ShowedPoints")
onready var Hit = get_parent().get_node("GUI/UI/Sprite/SCORE/Hit")
onready var Kill = get_parent().get_node("GUI/UI/Sprite/SCORE/Kill")
onready var points = 0
onready var hit = 0
onready var kill = 0
onready var ActualFightPhase = 0

var spawned = false
var positions : Array = []
var spawnList: Array = []
var menuShowed = false

func _ready() -> void:
	positions = $Positions.get_children()
	_select_stage(current_stage)
	
	randomize()
	

func _process(_delta: float) -> void:
	TotalPoints.text = str(points)
	showedPoints.text = str(points)
	Kill.text = str(kill)
	Hit.text = str(hit)
	
	for player in players:
		if player.global_position.x > wall.global_position.x - 750 && spawned == false && ActualFightPhase <= totalFightPhases - 1:
			_enemy_spawn(current_stage, ActualFightPhase)
		
	
	if $EnemiesContainer.get_child_count() == 0 && spawned == true && ActualFightPhase == totalFightPhases - 1:
		go.visible = true
		spawned = true
		
	
	if $EnemiesContainer.get_child_count() == 0 && spawned == true && ActualFightPhase < totalFightPhases - 1:
		spawned = false
		ActualFightPhase = ActualFightPhase + 1
		
	
	if win.visible == true:
		go.visible = false
	
	for player in players:
		if player.collision_shape.disabled == true:
			showedPoints.visible = false
			ScoreFolder.visible = true
			
			game_over.visible = true
		
	
	if Input.is_action_pressed("ui_accept") && game_over.visible == true:
		get_tree().change_scene("res://scenes/levels/" + current_level + ".tscn")
		
	
	if Input.is_action_pressed("ui_accept") && win.visible == true:
		next_stage = "res://scenes/levels/" + next_stage + ".tscn"
		get_tree().change_scene(next_stage)
		
	

func _select_stage(number):
	if positions.size() - 1 == number: 
		ScoreFolder.visible = true
		showedPoints.visible = false
		
		win.visible = true
		
		var pausable_members = get_tree().get_nodes_in_group("pausable")
		for member in pausable_members:
			member.pause()
			
		
	else:
		camera.limit_right = (positions[number + 1] as Position2D).global_position.x
		
		wall.global_position = (positions[number + 1] as Position2D).global_position
		
	

func _enemy_spawn(number, actualFightPhase):
	spawned = true
	var enemyNumber = NodePath((number) as String)
	var phase =  NodePath((actualFightPhase) as String)
	
	spawnList = $EnemiesSpawn.get_node(enemyNumber).get_node(phase).get_children()
	
	for spawn in spawnList:
		var rand_index:int = randi() % enemy_types.size()
		
		var enemy_instance = enemy_types[rand_index].instance()
		$EnemiesContainer.add_child(enemy_instance)
		enemy_instance.global_position = (spawn as Position2D).global_position
		enemy_instance.targetList = players
		
	

func _on_Player_death() -> void:
	var pausable_members = get_tree().get_nodes_in_group("pausable")
	
	for member in pausable_members:
		member.pause()
		
	


func _on_Player2_death():
	var pausable_members = get_tree().get_nodes_in_group("pausable")
	
	for member in pausable_members:
		member.pause()
