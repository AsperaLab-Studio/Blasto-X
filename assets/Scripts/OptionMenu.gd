extends Control

onready var miscMenu: Control = get_node("MiscMenu")
onready var optionMenu: Control = get_node("OptionMenu")

export var main: bool = false

var menuShowed: bool = false

func _process(delta):
	if Input.is_action_just_pressed("menu") && !main:
			if menuShowed == false:
				get_parent().get_parent().get_node("Player").paused = true
				var enemyList = get_parent().get_parent().get_node("StageManager/EnemiesContainer") .get_children()
				for enemy in enemyList:
					enemy.paused = true
					
				visible = true
				menuShowed = true
			else:
				get_parent().get_parent().get_node("Player").paused = false
				var enemyList = get_parent().get_parent().get_node("StageManager/EnemiesContainer") .get_children()
				for enemy in enemyList:
					enemy.paused = false
				menuShowed = false
				visible = false
				
			
		
	

func _on_ReturnBtn_pressed():
	if main:
		miscMenu.visible = true
		optionMenu.visible = false
		
	else:
		get_parent().get_parent().get_node("Player").paused = false
		var enemyList = get_parent().get_parent().get_node("StageManager/EnemiesContainer") .get_children()
		for enemy in enemyList:
			enemy.paused = false
		menuShowed = false
		visible = false
	
func _on_SFXSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value);

func _on_MusicSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value);

func _on_checkFullscreen_toggled(button_pressed: bool) -> void:
	OS.window_fullscreen = !OS.window_fullscreen

func _on_backToPauseBtn_pressed():
	var mainPauseMenu = get_node("mainPauseMenu")
	mainPauseMenu.visible = true
	optionMenu.visible = false

func _on_OptionBtn_pressed():
	var mainPauseMenu = get_node("mainPauseMenu")
	mainPauseMenu.visible = false
	optionMenu.visible = true

func _on_MainMenuBtn_pressed():
	get_tree().change_scene("res://scenes/misc/MainMenu.tscn")

func _on_QuitBtn_pressed():
	get_tree().quit()
