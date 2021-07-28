class_name Enemy
extends KinematicBody2D

onready var sprite: Sprite = $Sprite
onready var pivot: Node2D = $Pivot
onready var attack_delay_timer: Timer = $AttackDelayTimer
onready var cooldown_timer: Timer = $CooldownTimer
onready var anim_player : AnimationPlayer = $AnimationPlayer

enum STATE {CHASE, ATTACK, WAIT, HIT}

export(int) var speed := 500
export(int) var moving_speed := 50
export(int) var dps := 10

var current_state = STATE.CHASE

var target = null
var near_player: bool = false

func _ready():
	target = get_parent().get_node("Player")
	anim_player.play("idle")


func _process(delta: float) -> void:
	match current_state:
		STATE.HIT:
			move_and_slide(-global_position.direction_to(target.global_position) * speed)
			anim_player.play("hit")
		STATE.CHASE:
			anim_player.play("move")
			if !near_player:
				move_towards_target()
			else:
				current_state = STATE.WAIT
		STATE.WAIT:
			anim_player.play("idle")
			if attack_delay_timer.is_stopped():
				attack_delay_timer.wait_time = 0.5
				attack_delay_timer.start()
		STATE.ATTACK:
			if near_player:
				anim_player.play("attack")
		

func hit() -> void:
	print("enemy hit!")
	current_state = STATE.HIT
	$Tween.interpolate_property(self, "speed",
		500, 0, 0.3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	

func _on_Tween_tween_all_completed() -> void:
	current_state = STATE.CHASE
	

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
	if (area.owner.is_in_group("player")):
		near_player = true
	

func _on_Area2D_area_exited(area: Area2D) -> void:
	if (area.owner.is_in_group("player")):
		near_player = false
		current_state = STATE.CHASE
		attack_delay_timer.stop()
	

func attack():
	target.hit(dps)
	current_state = STATE.CHASE
	

func _on_Timer_timeout() -> void:
	current_state = STATE.ATTACK
