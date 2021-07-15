class_name Player
extends KinematicBody2D

onready var sprite: AnimatedSprite = $AnimatedSprite
onready var attack_collision: Area2D = $Pivot/AttackCollision 
onready var pivot: Node2D = $Pivot

export(int) var speed: int = 300
export(bool) var moving: bool = false
export(Vector2) var direction: = Vector2.ZERO
export(String) var state = "IDLE"

func _ready() -> void:
	sprite.play("idle")
	attack_collision.monitoring = false

func _process(delta: float) -> void:
	if state == "IDLE" && Input.is_action_just_pressed("attack"):
		state = "ATTACK"
		return
		
	if state == "ATTACK":
		attack_collision.monitoring = true
		sprite.play("attack")
		sprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
		return
		
	direction = _get_direction()
	
	if direction:
		if direction.x < 0:
			sprite.flip_h = true
			if pivot.scale.x > 0:
				pivot.scale.x = - pivot.scale.x
		elif direction.x > 0:
			sprite.flip_h = false
			if pivot.scale.x < 0:
				pivot.scale.x = - pivot.scale.x
		move_and_slide(direction * speed)
		sprite.play("move")
	else:
		sprite.play("idle")
	

func _on_AnimatedSprite_animation_finished():
	state = "IDLE"
	attack_collision.monitoring = false
	
	
func _on_AttackCollision_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("enemy"):
		var enemy = area.owner as Enemy
		enemy.hit()

func _get_direction() -> Vector2:
	var input_direction = Vector2()
	input_direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input_direction
		
