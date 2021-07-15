class_name Enemy
extends KinematicBody2D

export(int) var speed := 500
export(int) var moving_speed := 50
export(bool) var moving := false

var target = null


func _ready():
	target = get_parent().get_node("Player")


func _process(delta: float) -> void:
	if moving:
		move_and_slide(Vector2.RIGHT * speed)
	else:
		move_towards_target()
		

func hit() -> void:
	print("hit!")
	moving = true
	$Tween.interpolate_property(self, "speed",
		500, 0, 0.3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	

func _on_Tween_tween_all_completed() -> void:
	moving = false


func move_towards_target():
	if target:
		var velocity = global_position.direction_to(target.global_position)
		move_and_slide(velocity * moving_speed)
