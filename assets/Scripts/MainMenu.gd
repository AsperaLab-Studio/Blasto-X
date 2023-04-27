extends Control
export var firstTab = ""
export var thirdTab = ""

onready var miscMenu: Control = get_node("MiscMenu")
onready var optionMenu: Control = get_node("OptionMenu")

func _process(delta):
	if Input.is_action_just_pressed("skipBoss"):
		get_tree().change_scene("res://scenes/levels/LevelDesertBoss.tscn")

func _on_StartBtn_pressed():
	get_tree().change_scene("res://scenes/cutscenes/" + firstTab + ".tscn")

func _on_OptionsBtn_pressed():
	miscMenu.visible = false
	optionMenu.visible = true
	

func _on_CreditsBtn_pressed():
	get_tree().change_scene("res://scenes/cutscenes/" + thirdTab + ".tscn")
	

func _on_ExitBtn_pressed():
	get_tree().quit()
	
