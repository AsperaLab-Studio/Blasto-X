class_name BulletRifle
extends Node2D

var velocity = Vector2.ZERO
var direction = Vector2.RIGHT
onready var collider : CollisionShape2D = $BulletArea/CollisionShape2D

export(int) var speed: int = 700
export(int) var damage: int = 1
export(String) var target

func _ready():
	direction = Vector2(1, 0).rotated(rotation)
	collider.disabled = true

func _process(delta: float) -> void:
	velocity.x = speed * delta 
	
	#if direction.x < 0:
		#$Sprite.flip_v = true
	#position += velocity * direction


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
