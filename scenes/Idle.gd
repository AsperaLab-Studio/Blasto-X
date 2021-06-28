# Idle.gd
extends State

# Upon entering the state, we set the Player node's velocity to zero.
func enter(_msg := {}) -> void:
	# We must declare all the properties we access through `owner` in the `Player.gd` script.
	pass

func update(delta: float) -> void:
	_get_direction()
	
	if (owner.moving):
		state_machine.transition_to("Move")
	elif Input.is_action_pressed("attack"):
		state_machine.transition_to("Attack")
	else:
		owner.sprite.play("idle")
	
#state_machine.transition_to("Air", {do_jump = true})
func _get_direction():
	owner.moving = false
	
	if Input.is_action_pressed("move_right"):
		owner.moving = true
		owner.direction.x = 1		
		owner.sprite.flip_h = false
	if Input.is_action_pressed("move_left"):
		owner.moving = true
		owner.direction.x = -1
		owner.sprite.flip_h = true
	if Input.is_action_pressed("move_up"):
		owner.moving = true
		owner.direction.y = -1
	if Input.is_action_pressed("move_down"):
		owner.moving = true
		owner.direction.y = 1
