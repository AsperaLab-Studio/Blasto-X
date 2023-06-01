extends Node

var isMultiplayer: bool = false
var multiplayerReady: bool = false

var player1_input: InputEvent
var player2_input: InputEvent

func _ready():
	var test = Input.get_connected_joypads().size()
	pass

func _process(delta):
	if Input.get_connected_joypads().size() > 0:
		multiplayerReady = true
