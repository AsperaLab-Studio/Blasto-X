extends Node2D

onready var healthbar = $HealthBar
#healthbar.value = healthbar.value - amount


func _on_Player_update_healthbar(amount):
	healthbar.value = healthbar.value - amount
