extends Node

export var increment = 1566
export var y = 768
export var n_positions = 5
export(Array, PackedScene) var enemy_types
export(int) var current_stage := 0
export var next_stage = ""
export var current_level = ""

onready var sound = get_parent().get_node("ost")
onready var playersParent = get_parent().get_node("PlayersList")
onready var boss = get_node("EnemiesContainer").get_child(0)
onready var game_over: Sprite = get_parent().get_node("GUI/UI/GAME OVER")
onready var win = get_parent().get_node("GUI/UI/WIN")
onready var menu = get_parent().get_node("GUI/menu")
onready var respawnPoint = get_node("respawnPoint")

var menuShowed = false
var players

func _ready():
	players = playersParent.get_children()
	boss.targetList = players

func _process(_delta: float) -> void:
	
	players = playersParent.get_children()

	if is_instance_valid(boss):
		boss.targetList = players
		
		checkPlayersDead()
		
	if $EnemiesContainer.get_child_count() == 0:
		win.visible = true
		var pausable_members = get_tree().get_nodes_in_group("pausable")
		for member in pausable_members:
			member.pause()
	
	if Input.is_action_pressed("ui_accept") && game_over.visible == true:
		get_tree().change_scene("res://scenes/levels/" + current_level + ".tscn")
		
	
	if Input.is_action_pressed("ui_accept") && win.visible == true:
		var save_data = SaveManager.save_data.new()
		save_data.current_level = current_level

		# Salvataggio dei dati
		SaveManager.save_game("save_data.dat", save_data)

		Global.score = 0
		next_stage = "res://scenes/cutscenes/" + next_stage + ".tscn"
		get_tree().change_scene(next_stage)
		
	

func checkPlayersDead():
	if players.size() == 0:
		game_over.visible = true

		var pausable_members = get_tree().get_nodes_in_group("pausable")
		for member in pausable_members:
			member.pause()
	

func _on_Blasto_death(p) -> void:
	eventDeath(p)
	

func _on_Ceru_Star_death(p):
	eventDeath(p)


func eventDeath(p):
	if(p.lifeCount > 0):
		respawn(p)
	else:
		for playerTmp in players:
			if playerTmp != p:
				if playerTmp.lifeCount == 0:
					var pausable_members = get_tree().get_nodes_in_group("pausable")
		
					for member in pausable_members:
						member.pause()
					
				
			
		
	


func respawn(p):
	var tmp = Vector2(respawnPoint.global_position.x, p.global_position.y)
	p.global_position = tmp
