class_name Missile
extends TurianWeapon

func _ready():
	pass # Replace with function body.


func shoot(player):
	var playerRef := player as Player
	var bullet_instance = bullet.instance()
	bullet_instance.direction = playerRef.global_position - position2d.position
	get_parent().add_child(bullet_instance)
	bullet_instance.global_transform = position2d.global_transform

