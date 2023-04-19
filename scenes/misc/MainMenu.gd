extends Control
export var firstTab = ""
export var thirdTab = ""

var positions = []
var index = 0

onready var startBtn: Button = get_node("StartBtn")
onready var optionBtn: Button = get_node("OptionsBtn")
onready var creditsBtn: Button = get_node("CreditsBtn")
onready var exitBtn: Button = get_node("ExitBtn")
onready var returnBtn: Button = get_node("ReturnBtn")

onready var musicLabel: Label = get_node("music")
onready var sfxLabel: Label = get_node("sfx")
onready var musicSlider: HSlider = get_node("MusicSlider")
onready var sfxSlider: HSlider = get_node("SFXSlider")
onready var fullscreen: CheckBox = get_node("checkFullscreen")

func _ready():
	for node in get_parent().get_children():
		if node is Label and node.visible:
			positions.append(node)
		
	

func _on_SFXSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value);

func _on_MusicSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value);

func _on_checkFullscreen_toggled(button_pressed: bool) -> void:
	OS.window_fullscreen = !OS.window_fullscreen

func _on_StartBtn_pressed():
	get_tree().change_scene("res://scenes/cutscenes/" + firstTab + ".tscn")

func _on_OptionsBtn_pressed():
	startBtn.visible = false
	optionBtn.visible = false
	creditsBtn.visible = false
	exitBtn.visible = false
	
	musicLabel.visible = true
	sfxLabel.visible = true
	musicSlider.visible = true
	sfxSlider.visible = true
	returnBtn.visible = true
	fullscreen.visible = true

func _on_ReturnBtn_pressed():
	startBtn.visible = true
	optionBtn.visible = true
	creditsBtn.visible = true
	exitBtn.visible = true
	
	musicLabel.visible = false
	sfxLabel.visible = false
	musicSlider.visible = false
	sfxSlider.visible = false
	returnBtn.visible = false
	fullscreen.visible = false

func _on_CreditsBtn_pressed():
	get_tree().change_scene("res://scenes/cutscenes/" + thirdTab + ".tscn")

func _on_ExitBtn_pressed():
	get_tree().quit()
