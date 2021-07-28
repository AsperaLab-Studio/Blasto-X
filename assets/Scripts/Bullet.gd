extends Node2D

var velocity = Vector2.ZERO
var direction = Vector2.RIGHT

export(int) var speed: int = 300

func _process(delta: float) -> void:
	velocity.x = speed * delta 
	
	if direction == Vector2.LEFT:
		$Sprite.flip_v = true
	
	position += velocity * direction
