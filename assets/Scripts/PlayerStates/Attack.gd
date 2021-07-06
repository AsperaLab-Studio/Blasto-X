extends PlayerState

signal attack


func enter(_msg := {}) -> void:#{
	player.attack_collision.monitoring = true
	
	player.sprite.play("attack")
	
	player.sprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
#}

func _on_AnimatedSprite_animation_finished():#{
	state_machine.transition_to("Idle")
#}
	
func exit() -> void:#{
	player.attack_collision.monitoring = false
#}

func _on_AttackCollision_area_entered(area: Area2D) -> void:#{
	if area.owner.is_in_group("enemy"):#{
		var enemy = area.owner as Enemy
		enemy.hit()
	#}
#}
