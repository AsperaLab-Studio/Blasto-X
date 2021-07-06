extends PlayerState


func update(delta: float) -> void:#{
	player.move_and_slide(player.direction*player.speed)
	player.sprite.play("move")
	
	_get_direction()
	
	if(player.direction == Vector2.ZERO):#{
		state_machine.transition_to("Idle")
	#}
#}

func _get_direction():#{
	player.moving = false
	player.direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):#{
		player.moving = true
		player.direction.x = 1
		player.sprite.flip_h = false
	#}
	if Input.is_action_pressed("move_left"):#{
		player.moving = true
		player.direction.x = -1
		player.sprite.flip_h = true
	#}
	if Input.is_action_pressed("move_up"):#{
		player.moving = true
		player.direction.y = -1
	#}
	if Input.is_action_pressed("move_down"):#{
		player.moving = true
		player.direction.y = 1
	#}
#}
