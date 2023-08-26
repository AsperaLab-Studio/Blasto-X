class_name Grenade
extends TurianWeapon

func _process(_delta):
	pass
	
func shoot(player):
	var bullet_instance = bullet.instance()
	bullet_instance.direction = Vector2(-1,0)
	get_parent().add_child(bullet_instance)
	bullet_instance.global_transform = position2d.global_transform
