extends Node

var isMultiplayer: bool = false
var multiplayerReady: bool = false

var player1_input
var player2_input

func _ready():
	player1_input = InputEvent.new
	player2_input = InputEvent.new

func _process(delta):
	if Input.get_connected_joypads().size() > 0:
		multiplayerReady = true
