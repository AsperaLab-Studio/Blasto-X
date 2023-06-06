extends Control

export var thirdTab = ""

onready var optionMenu: Control = get_parent().get_node("OptionMenu")
onready var playMenu: Control = get_parent().get_node("PlayMenu")

func _process(_delta):
	if Input.is_action_just_pressed("skipBoss"):
		get_tree().change_scene("res://scenes/levels/LevelDesertBoss.tscn")

func _on_StartBtn_pressed():
	visible = false
	playMenu.visible = true
	var multiBtn = playMenu.get_node("MultiBtn")
	if(Global.multiplayerReady == true):
		multiBtn.visible = true
	else:
		multiBtn.visible = false
	

func _on_OptionsBtn_pressed():
	visible = false
	optionMenu.visible = true
	

func _on_CreditsBtn_pressed():
	get_tree().change_scene("res://scenes/cutscenes/" + thirdTab + ".tscn")
	

func _on_ExitBtn_pressed():
	get_tree().quit()
	
