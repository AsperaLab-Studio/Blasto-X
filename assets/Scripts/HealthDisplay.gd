extends Node2D

var bar_red = preload("res://assets/img/barHorizontal_red.png")
var bar_green = preload("res://assets/img/barHorizontal_green.png")
var bar_yellow = preload("res://assets/img/barHorizontal_yellow.png")
var bar_orange = preload("res://assets/img/barHorizontal_orange.png")

onready var healthbar = $HealthBar

func update_healthbar(amount):
	healthbar.value = healthbar.value - amount
	healthbar.texture_progress = bar_red
	if healthbar.value < healthbar.max_value * 0.7:
		healthbar.texture_progress = bar_yellow
	if healthbar.value < healthbar.max_value * 0.35:
		healthbar.texture_progress = bar_orange
	
