class_name Enemy
extends KinematicBody2D

onready var sprite: Sprite = $Sprite
onready var pivot: Node2D = $Pivot

export(int) var speed := 500
export(int) var moving_speed := 50
export(bool) var moving := false

var target = null
var near_player: bool = false

func _ready():
	target = get_parent().get_node("Player")


func _process(delta: float) -> void:
	if moving:
		move_and_slide(-global_position.direction_to(target.global_position) * speed)
	elif !near_player:
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
		if global_position.y > target.global_position.y:
			z_index = 0
		else:
			z_index = -1
			
		var velocity = global_position.direction_to(target.global_position)
		
		if velocity.x < 0:
			sprite.flip_h = true
			if pivot.scale.x > 0:
				pivot.scale.x = - pivot.scale.x
		elif velocity.x > 0:
			sprite.flip_h = false
			if pivot.scale.x < 0:
				pivot.scale.x = - pivot.scale.x
				
		move_and_slide(velocity * moving_speed)
	

func _on_Area2D_area_entered(area: Area2D) -> void:
	if(area.owner.is_in_group("player")):
		near_player = true


func _on_Area2D_area_exited(area: Area2D) -> void:
	if(area.owner.is_in_group("player")):
		near_player = false
