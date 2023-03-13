class_name KroganBoss
extends KinematicBody2D

onready var sprite: Sprite = $Sprite
onready var pivot: Node2D = $Pivot
onready var attack_delay_timer: Timer = $AttackDelayTimer
onready var cooldownShake_timer: Timer = $CooldownShakeTimer
onready var timerShake: Timer = $TimerShake
onready var cooldownCharge_timer: Timer = $CooldownChargeTimer
onready var timerCharge: Timer = $TimerCharge
onready var anim_player : AnimationPlayer = $AnimationPlayer
onready var collision_shape : CollisionShape2D = $HitBox/CollisionShape2D
onready var collision_shape_body : CollisionShape2D = $CollisionShape2D
onready var collition_area2d : CollisionShape2D = $Pivot/AttackCollision/CollisionShape2D
onready var player: Player = get_parent().get_parent().get_parent().get_node("Player")
onready var UIHealthBar: Node2D = get_parent().get_parent().get_parent().get_node("GUI/UI2/MarginContainer2")
enum STATE {CHASE, ATTACK, SHAKE, CHARGE, WAIT, IDLE, HIT, DIED}

export(int) var speed := 500
export(int) var death_speed := 150
export(int) var moving_speed := 50
export(int) var dps := 10
export(int) var dpsCharge := 20
export(int) var HP := 5
export(float) var ShakeDuration := 5
export(float) var ShakeDeelay := 5
export(float) var ChargeDeelay := 5

var current_state = STATE.CHASE

var targetPositionStamp = Vector2()
var near_player: bool = false
var near_enemy: bool = false
var shakeFree: bool = false
var chargeFree: bool = false
var healthBar = null
var amount = 0
var paused = false

var sceneManager = null

func _ready():
	anim_player.play("idle")
	healthBar = UIHealthBar
	
	sceneManager = get_parent().get_parent()
	cooldownShake_timer.wait_time = ShakeDeelay
	cooldownShake_timer.one_shot = true
	cooldownShake_timer.start()
	cooldownCharge_timer.wait_time = ChargeDeelay
	cooldownCharge_timer.one_shot = true
	cooldownCharge_timer.start()
	

func _process(delta: float) -> void:
	#if shakeFree:
		#current_state = STATE.SHAKE
	if chargeFree:
		current_state = STATE.CHARGE
	
	if(!paused):
		match current_state:
			STATE.HIT:
				anim_player.play("hit")
			STATE.CHASE:
				anim_player.play("move")
				if !near_player:
					move_towards(player.global_position)
				else:
					current_state = STATE.WAIT
			STATE.WAIT:
				if near_player:
					anim_player.play("idle")
					if attack_delay_timer.is_stopped():
						attack_delay_timer.wait_time = 1
						attack_delay_timer.start()
				else:
					current_state = STATE.CHASE
			STATE.IDLE:
				anim_player.play("idle")
				if !near_enemy:
					current_state = STATE.WAIT
			STATE.ATTACK:
					if near_player && !player.invincible:
						anim_player.play("attack")
					else:
						current_state = STATE.WAIT
						attack_delay_timer.stop()
			STATE.SHAKE:
				if timerShake.is_stopped() && shakeFree:
					anim_player.play("shake")
					current_state = STATE.IDLE
			STATE.CHARGE:
				if timerCharge.is_stopped() && chargeFree:
					anim_player.play("ChargeStart")
					move_towards(targetPositionStamp)
			STATE.DIED:
				collision_shape_body.disabled = true
				collision_shape.disabled = true
				
				collition_area2d.disabled = true
				
				anim_player.play("died")
				
				var direction = Vector2((global_position.x - player.global_position.x), 0).normalized()
				
				move_and_slide(direction * death_speed)
				
			
		
		$HealthDisplay/Label.text = STATE.keys()[current_state]
	else:
		anim_player.stop()
	

func nothing ():
	pass

func hit(dps) -> void:
	healthBar.update_healthbar(dps)
	amount = amount + dps
	if amount >= HP:
		current_state = STATE.DIED
	else:
		current_state = STATE.HIT
	

func shake(): 
	shakeFree = false
	player.camera.smoothing_speed = 5
	player.camera.shaked = true
	timerShake.wait_time = ShakeDuration
	timerShake.one_shot = true
	player.paused = true
	timerShake.start()
	cooldownShake_timer.wait_time = ShakeDeelay
	cooldownShake_timer.one_shot = true
	cooldownShake_timer.start()

func set_state_idle():
	player.camera.smoothing_speed = 0
	player.camera.shaked = false
	player.paused = false
	

func ChargeStart():
	targetPositionStamp.x = player.global_position.x
	targetPositionStamp.y = player.global_position.y
	anim_player.play("ChargeMid")
	

func move_towards(target: Vector2):
	if target:
		if global_position.y > target.y:
			z_index = 0
		else:
			z_index = -1
			
		var velocity = global_position.direction_to(target)
		
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
	if current_state == STATE.CHARGE:
		anim_player.play("ChargeEnd")
		if (area.owner.is_in_group("player")):
			player.hit(dpsCharge)
	else:
		if (area.owner.is_in_group("player")):
			near_player = true
		
		if(area.owner.is_in_group("enemy")):
			current_state = STATE.IDLE
			near_enemy = true
	

func pause():
	anim_player.stop()
	set_process(false)
	

func _on_Area2D_area_exited(area: Area2D) -> void:
	if current_state == STATE.DIED:
		pass
	elif area.owner && area.owner.is_in_group("player"):
		near_player = false
		#current_state = STATE.CHASE
		#attack_delay_timer.stop()
	if area.owner && area.owner.is_in_group("enemy"):
		near_enemy = false
	

func attack():
	player.hit(dps)
	

func death():
	queue_free()
	

func _on_Timer_timeout() -> void:
	if current_state == STATE.WAIT:
		current_state = STATE.ATTACK
	

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "attack":
		current_state = STATE.CHASE
	if anim_name == "hit":
		current_state = STATE.CHASE
		
	

func _on_TimerShake_timeout():
	set_state_idle()

func _on_TimerCharge_timeout():
	set_state_idle()

func _on_CooldownShakeTimer_timeout():
	shakeFree = true

func _on_CooldownChargeTimer_timeout():
	chargeFree = true
