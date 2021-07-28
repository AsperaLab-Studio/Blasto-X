class_name Player
extends KinematicBody2D

onready var sprite: Sprite = $Sprite
onready var attack_collision: Area2D = $Pivot/AttackCollision 
onready var pivot: Node2D = $Pivot
onready var anim_player: AnimationPlayer = $AnimationPlayer

enum STATE {IDLE, MOVE, ATTACK, HIT, SHOOT, WIN, LOSE}

export(int) var speed: int = 300
export(bool) var moving: bool = false
export(Vector2) var direction: = Vector2.ZERO

var current_state = STATE.IDLE
var healthBar = null

export var collidings_areas = []

func _ready() -> void:
	anim_player.play("idle")
	healthBar = get_parent().get_node("UI").get_node("HealthDisplay")

func _process(delta: float) -> void:
	
	direction = _get_direction()
	
	match current_state:
		STATE.IDLE:
			if Input.is_action_just_pressed("attack"):
				current_state = STATE.ATTACK
				
			if direction:
				current_state = STATE.MOVE
			else:
				anim_player.play("idle")
				
		STATE.ATTACK:
			anim_player.play("attack")

		STATE.MOVE:
			if direction.x < 0:
				sprite.flip_h = true
				if pivot.scale.x > 0:
					pivot.scale.x = - pivot.scale.x
			elif direction.x > 0:
				sprite.flip_h = false
				if pivot.scale.x < 0:
					pivot.scale.x = - pivot.scale.x
			move_and_slide(direction * speed)
			anim_player.play("move")
			
			if !direction:
				current_state = STATE.IDLE
		

func attack():
	for area in collidings_areas:
		if area.owner.is_in_group("enemy"):
			var enemy = area.owner
			enemy.hit()


func _get_direction() -> Vector2:
	var input_direction = Vector2()
	input_direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input_direction
		

func hit(dps):
	print("player hit!")
	var amount = 0
	amount = dps
	healthBar.update_healthbar(amount)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "attack":
		current_state = STATE.IDLE


func _on_AttackCollision_area_entered(area: Area2D) -> void:
	collidings_areas.append(area)


func _on_AttackCollision_area_exited(area: Area2D) -> void:
	collidings_areas.erase(area)
