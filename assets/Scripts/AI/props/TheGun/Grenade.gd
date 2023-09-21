class_name Grenade
extends TurianWeapon

func shoot(player):
	var playerRef := player as Player
	var bullet_instance = bullet.instance()
	bullet_instance.direction = playerRef.global_position - position2d.global_position
	get_parent().get_parent().get_parent().get_parent().add_child(bullet_instance)
	bullet_instance.set_global_position(position2d.get_global_position())
