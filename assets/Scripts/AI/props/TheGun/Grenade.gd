class_name Grenade
extends TurianWeapon

export(int) var zonesAmount = 4

var total_impact_zones: Array
var rng

func _ready():
	rng = RandomNumberGenerator.new()

func shoot(player):
	var impactZones: Array

	for n in zonesAmount - 1:
		randomize()
		var randomPos = int(rand_range(0, total_impact_zones.size()-1))
		impactZones.append(total_impact_zones[randomPos])
		total_impact_zones.remove(randomPos)

	for n in zonesAmount - 1:
		(impactZones[n] as ImpactZone).activate()

	var bullet_instance = bullet.instance()
	get_parent().get_parent().get_parent().get_parent().add_child(bullet_instance)
	bullet_instance.set_global_position(position2d.get_global_position())
