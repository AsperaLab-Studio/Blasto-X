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
	move_and_slide(direction*speed)

func _get_direction() -> Vector2:
	var direction: = Vector2()
	
	if Input.is_action_pressed("move_right"):
		direction.x = 1
	if Input.is_action_pressed("move_left"):
		direction.x = -1
	if Input.is_action_pressed("move_up"):
		direction.y = -1
	if Input.is_action_pressed("move_down"):
		direction.y = 1
	
	return direction
