class_name PowerUp
extends Node2D

onready var collider: CollisionShape2D = $Sprite/Area2D/CollisionShape2D

enum POWER_UP_TYPE {GUN, MEDIKIT}

export(POWER_UP_TYPE) var type
export(int) var amount

var entered: bool = false

func _on_Area2D_area_entered(area:Area2D):
	if area.owner && area.owner.is_in_group("player"):
		match(type):
			POWER_UP_TYPE.GUN:
				pass
			POWER_UP_TYPE.MEDIKIT:
				if area.owner.current_hp != area.owner.hp:
					entered = true
					Wwise.register_game_obj(self.get_parent(), self.get_parent().name)
					Wwise.post_event_id(AK.EVENTS.PICK_UP_HEAL, self.get_parent())
					$Sprite/Area2D/CollisionShape2D.disabled = true
					$Sprite.visible = false
					if area.owner.current_hp + amount >= area.owner.hp:
						area.owner.current_hp = area.owner.hp
					else:
						area.owner.current_hp = area.owner.current_hp + amount
						
					area.owner.emit_signal("update_healthbar", area.owner.current_hp)
					queue_free()
