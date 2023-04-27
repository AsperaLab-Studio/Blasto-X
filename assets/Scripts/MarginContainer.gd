extends MarginContainer


var bar_red = preload("res://assets/img/UI/barHorizontal_red.png")
var bar_green = preload("res://assets/img/UI/barHorizontal_green.png")
var bar_yellow = preload("res://assets/img/UI/barHorizontal_yellow.png")

onready var healthbar = get_parent().get_node("HealthBar")

func _on_Player_update_healthbar(amount) -> void:
	healthbar.value = healthbar.value - amount
