extends Node

export var increment = 1566
export var y = 768
export var n_positions = 5
export(Array, PackedScene) var enemy_types
export(int) var current_stage := 0
export var next_stage = ""
export var current_level = ""

onready var sound = get_parent().get_node("ost")
onready var players = get_parent().get_node("PlayersList").get_children()
onready var game_over: Sprite = get_parent().get_node("GUI/UI/GAME OVER")
onready var win = get_parent().get_node("GUI/UI/WIN")
onready var menu = get_parent().get_node("GUI/menu")

var menuShowed = false

func _process(delta: float) -> void:
	for player in players:
		if player.collision_shape.disabled == true:
			game_over.visible = true
		
	
	if $EnemiesContainer.get_child_count() == 0:
		win.visible = true
		var pausable_members = get_tree().get_nodes_in_group("pausable")
		for member in pausable_members:
			member.pause()
	
	if Input.is_action_pressed("ui_accept") && game_over.visible == true:
		get_tree().change_scene("res://scenes/levels/" + current_level + ".tscn")
		
	
	if Input.is_action_pressed("ui_accept") && win.visible == true:
		next_stage = "res://scenes/cutscenes/" + next_stage + ".tscn"
		get_tree().change_scene(next_stage)
		
	

func _on_Blasto_death() -> void:
	var pausable_members = get_tree().get_nodes_in_group("pausable")
	
	for member in pausable_members:
		member.pause()
		
	


func _on_Ceru_Star_death():
	var pausable_members = get_tree().get_nodes_in_group("pausable")
	
	for member in pausable_members:
		member.pause()
		
	
