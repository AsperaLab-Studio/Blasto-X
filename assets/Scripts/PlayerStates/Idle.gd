extends PlayerState


func update(delta: float) -> void:
	_get_direction()
	
	if (player.moving):
		state_machine.transition_to("Move")
		return
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")
		return
	else:
		player.sprite.play("idle")
	

func _get_direction():
	player.moving = false
	
	if Input.is_action_pressed("move_right"):
		player.moving = true
		player.direction.x = 1
	if Input.is_action_pressed("move_left"):
		player.moving = true
		player.direction.x = -1
	if Input.is_action_pressed("move_up"):
		player.moving = true
		player.direction.y = -1
	if Input.is_action_pressed("move_down"):
		player.moving = true
		player.direction.y = 1
