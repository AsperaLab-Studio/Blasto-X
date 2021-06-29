class_name Enemy
extends KinematicBody2D

export(int) var speed := 500
export(bool) var moving := false


func _process(delta: float) -> void:
	if moving:
		move_and_slide(Vector2.RIGHT * speed)
		

func hit() -> void:
	print("hit!")
	moving = true
	$Tween.interpolate_property(self, "speed",
		500, 0, 0.3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	

func _on_Tween_tween_all_completed() -> void:
	moving = false
