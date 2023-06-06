extends Node2D

onready var playerParent = get_parent().get_node("PlayersList")

var playerList

func _ready():
	playerList = playerParent.get_children()

func _process(delta):
	playerList = playerParent.get_children()
	
	for player in playerList:
		if !player.isPlayerTwo
