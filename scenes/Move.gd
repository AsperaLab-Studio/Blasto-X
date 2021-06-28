extends State


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

func update(delta: float) -> void:
	owner.move_and_slide(owner.direction*owner.speed)
	owner.sprite.play("move")
	
	_get_direction()
	
	if(owner.direction == Vector2.ZERO):
		state_machine.transition_to("Idle")
		
func _get_direction():
	owner.moving = false
	owner.direction = Vector2.ZERO
	
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
