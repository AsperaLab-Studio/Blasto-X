class_name BulletRifle
extends Node2D

var velocity = Vector2.ZERO
var direction

export(int) var speed: int = 700
export(int) var damage: int = 1
export(String) var target

func _process(delta: float) -> void:
	velocity = speed * delta
	
	position += velocity * direction


func _on_BulletArea_area_entered(area):
	if area.owner.is_in_group(target):
		var enemy = area.owner
		enemy.hit(damage, self)
		$BulletArea.monitorable = false
		queue_free()

func _on_Timer_timeout():
	queue_free()
