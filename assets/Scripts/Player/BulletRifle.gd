class_name BulletRifle
extends Node2D

onready var collider : CollisionShape2D = $BulletArea/CollisionShape2D

var velocity = Vector2.ZERO
var direction

export(int) var speed: int = 700
export(int) var damage: int = 1
export(String) var target

func _process(delta: float) -> void:
	var new_position = position + direction * speed * delta

	# Aggiorna la posizione dell'oggetto
	position = new_position


func _on_BulletArea_area_entered(area):
	if area.owner.is_in_group(target):
		var enemy = area.owner
		enemy.hit(damage, self)
		$BulletArea.monitorable = false
		queue_free()

func _on_Timer_timeout():
	queue_free()


func _on_CollisionTimer_timeout():
	collider.disabled = false
