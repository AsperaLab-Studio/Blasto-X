extends Node2D

var velocity = Vector2.ZERO
var direction = Vector2.RIGHT

export(int) var speed: int = 700
export(int) var damage: int = 1

func _process(delta: float) -> void:
	velocity.x = speed * delta 
	
	if direction == Vector2.LEFT:
		$Sprite.flip_v = true
	
	position += velocity * direction


func _on_BulletArea_area_entered(area):
	if area.owner.is_in_group("enemy"):
		var enemy = area.owner
		enemy.hit(damage)
		$BulletArea.monitorable = false
		queue_free()
