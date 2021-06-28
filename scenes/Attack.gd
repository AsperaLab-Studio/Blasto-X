extends State


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	owner.sprite.play("attack")
	
	owner.sprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	owner.attack_collision.connect("body_entered", self, "_on_AttackCollision_body_entered")

func _on_AnimatedSprite_animation_finished():
	state_machine.transition_to("Idle")
	
func _on_AttackCollision_body_entered():
	print("attacco")
