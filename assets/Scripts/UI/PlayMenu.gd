extends Control

export var firstTab = ""

onready var miscMenu: Control = get_parent().get_node("MiscMenu")

func _on_SingleBtn_pressed():
	Global.isMultiplayer = false
	get_tree().change_scene("res://scenes/cutscenes/" + firstTab + ".tscn")


func _on_BackBtn_pressed():
	visible = false
	miscMenu.visible = true


func _on_MultiBtn_pressed():
	Global.isMultiplayer = true
	get_tree().change_scene("res://scenes/cutscenes/" + firstTab + ".tscn")


func _on_LoadBtn_pressed():
	var loaded_data = SaveManager.load_game(Global.save_path)
	if loaded_data:
		get_tree().change_scene("res://scenes/levels/" + loaded_data.current_level + ".tscn")
