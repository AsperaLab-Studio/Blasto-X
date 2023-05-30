extends Node2D

onready var healthbar = $HealthBar
onready var healthbar2 = $HealthBar2
#healthbar.value = healthbar.value - amount


func _on_Player_update_healthbar(amount):
	healthbar.value = healthbar.value - amount


func _on_Player2_update_healthbar(amount):
	healthbar2.value = healthbar2.value - amount
