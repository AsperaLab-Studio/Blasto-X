extends Control

onready var miscMenu: Control = get_parent().get_node("MiscMenu")
onready var optionMenu: Control = get_node("OptionMenu")
onready var commandMenu: Control = get_parent().get_node("CommandMenu")

export var main: bool = false

var menuShowed: bool = false

func _process(_delta):
	if (Input.is_action_just_pressed(Global.player1_input[6]) || Input.is_action_just_pressed(Global.player2_input[6])) && !main:
		get_tree().paused = !get_tree().paused
		visible = !visible
			
	

func _on_ReturnBtn_pressed():
	if main:
		miscMenu.visible = true
		visible = false
		
	else:
		get_tree().paused = !get_tree().paused
		visible = !visible
	
func _on_SFXSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value);

func _on_MusicSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value);

func _on_checkFullscreen_toggled(_button_pressed: bool) -> void:
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
	get_tree().paused = !get_tree().paused
	visible = !visible
	get_tree().change_scene("res://scenes/misc/MainMenu.tscn")

func _on_QuitBtn_pressed():
	get_tree().quit()


func _on_CommandBtn_pressed():
	commandMenu.visible = true
	visible = false
