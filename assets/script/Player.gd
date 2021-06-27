extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sprite: AnimatedSprite = $AnimatedSprite
export(int) var speed: int = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = _get_direction()
	
	if (Input.is_action_pressed("move_right")) or (Input.is_action_pressed("move_left")) or (Input.is_action_pressed("move_up")) or (Input.is_action_pressed("move_down")):
		move_and_slide(direction*speed)
	else:
		sprite.play("idle")
	

func _get_direction() -> Vector2:
	var direction: = Vector2()
	
	if Input.is_action_pressed("move_right"):
		sprite.play("move")
		direction.x = 1
	if Input.is_action_pressed("move_left"):
		sprite.play("move")
		direction.x = -1
	if Input.is_action_pressed("move_up"):
		sprite.play("move")
		direction.y = -1
	if Input.is_action_pressed("move_down"):
		sprite.play("move")
		direction.y = 1
	
	return direction
