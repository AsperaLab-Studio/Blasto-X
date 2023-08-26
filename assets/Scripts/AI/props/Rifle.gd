class_name Rifle
extends TurianWeapon

export(int) var numberOfBullets
export(float) var shootingAmplitude

func shoot(player):
	var deltaAngle = shootingAmplitude/(numberOfBullets -1)
	var playerRef := player as Player
	var direction = playerRef.global_position - position2d.position
	var numerator = (direction.position.x * direction.position.y + playerRef.global_position.x * playerRef.global_position.y)
	var denominator = (sqrt(powFunctionSum(direction.position.x, direction.position.y, 2)) *sqrt( powFunctionSum(playerRef.global_position.x, playerRef.global_position.y, 2)))
	var angle = numerator / denominator
	var i = 0
	for n in numberOfBullets:
		var bullet_instance = bullet.instance()
		bullet_instance.global_transform.position = direction + position2d.position
		var angleOffset = shootingAmplitude/2 - deltaAngle * i
		bullet_instance.global_transform.rotation = angle + angleOffset
		#direction to calculate = shootingAmplitude/2 - deltaAngle * i
		get_parent().add_child(bullet_instance)
		#to set
		i+=1


func powFunctionSum(value1 : float, value2 : float, base : float) -> float:
	return (pow(value1, base) + pow(value2, base))
