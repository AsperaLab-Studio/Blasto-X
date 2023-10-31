class_name asariBoss
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
onready var UIHealthBar: Node2D = get_parent().get_parent().get_parent().get_node("GUI/UI/HealthBossContainer")
onready var camera: Camera2D = get_parent().get_parent().get_parent().get_node("Camera2D")
enum STATE {CHASE, ATTACK, JUMP_START, JUMP_MID,JUMP_FINISH, SPRINT, WAIT, HIT, DIED}

export(int) var death_speed := 150
export(int) var moving_speed := 50
export(int) var charge_speed := 100
export(float) var jump_speed := 50
export(float) var fall_speed := 50
export(int) var dpsAttack := 10
export(int) var dpsSprint := 20
export(int) var dpsLanding := 15
export(int) var HP := 5
export(float) var ShakeDuration := 5.0
export(float) var ShakeDeelay := 5.0
export(float) var ChargeDeelay := 5.0

var current_state = STATE.CHASE
var actual_target: Player = null
var directionPlayer = Vector2()
var directionJump = Vector2()
var near_player: bool = false
var near_enemy: bool = false
var healthBar = null
var amount = 0
var paused = false
var areaCollided = null
var targetList = null
var actual_dps = dpsAttack

var chargeFree: bool = false

var sceneManager = null

func _ready():
	anim_player.play("idle")
	healthBar = UIHealthBar
	
	sceneManager = get_parent().get_parent()
	

func _process(_delta: float) -> void:
	actual_target = select_target()
	
	if(!paused):

		match current_state:
			STATE.HIT:
				anim_player.play("hit")
				
			STATE.CHASE:
				anim_player.play("move")
				if !near_player:
					move_towards(actual_target.global_position, moving_speed)
				else:
					current_state = STATE.WAIT
					
			STATE.WAIT:
				if near_player:
					anim_player.play("idle")
					
			STATE.ATTACK:
				actual_dps = dpsAttack
				if near_player && !actual_target.invincible:
						anim_player.play("attack")
				elif anim_player.current_animation != "attack":
					current_state = STATE.WAIT
					attack_delay_timer.stop()
					
			STATE.JUMP_START:
				anim_player.play("JumpStart")
				move_and_slide(Vector2(global_position.x, directionJump.y) * jump_speed)
				#signal for asari boss manager
				
			STATE.JUMP_MID:
				global_position = (Vector2(directionPlayer.x, global_position.y))
				current_state = STATE.JUMP_FINISH
				
			STATE.JUMP_FINISH:
				actual_dps = dpsLanding
				directionPlayer = actual_target
				anim_player.play("JumpFinish")
				move_towards(Vector2(global_position.x, directionPlayer.y), fall_speed)
				anim_player.play("Landing")
				#area damage
				current_state = STATE.WAIT
				
			STATE.SPRINT:
				actual_dps = dpsSprint
				
				var targetPositionStamp = Vector2()
				targetPositionStamp.x = actual_target.global_position.x
				targetPositionStamp.y = actual_target.global_position.y
				directionPlayer = Vector2((targetPositionStamp.x - global_position.x), (targetPositionStamp.y - global_position.y)).normalized()
				move_towards(directionPlayer, charge_speed)
				
				if anim_player.current_animation != "Sprint":
					current_state = STATE.WAIT
				
			STATE.DIED:
				collision_shape_body.disabled = true
				collision_shape.disabled = true
				
				collition_area2d.disabled = true
				
				anim_player.play("died")
				
				var directionDead = Vector2((global_position.x - actual_target.global_position.x), 0).normalized()
				
				move_and_slide(directionDead * death_speed)
				
			
		
		$HealthDisplay/Label.text = STATE.keys()[current_state]
	else:
		anim_player.stop()
	

func select_target() -> Player:
	var distance: float = 100000
	var choosedTarget: Player = null
	for target in targetList:
		var tmpDistance: float = global_position.distance_to(target.global_position)
		if(tmpDistance < distance):
			choosedTarget = target 
			distance = tmpDistance
	
	return choosedTarget


func hit(dpsTaken, attackType, source) -> void:
	if (current_state != STATE.JUMP_START && current_state != STATE.JUMP_MID 
		&& current_state != STATE.JUMP_FINISH && current_state != STATE.CHARGE):
		healthBar.update_healthbar(dpsTaken)
		amount = amount + dpsTaken
		if amount >= HP:
			current_state = STATE.DIED
		else:
			current_state = STATE.HIT
	
func move_towards(target: Vector2, speed): #!!! to use instead move_and_slide?
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
				
		move_and_slide(velocity * speed)
	

func attack():
	actual_target.hit(actual_dps, self)
	

func death():
	queue_free()
	

func pause():
	anim_player.stop()
	set_process(false)
	
func _on_Area2D_area_entered(area: Area2D) -> void:
	if current_state == STATE.SPRINT:
		if area.name != "BulletArea":
			anim_player.play("ChargeEnd")
			current_state = STATE.CHARGE_END
			if (area.owner.is_in_group("player")):
				areaCollided = area
	else:
		if (area.owner.is_in_group("player")):
			near_player = true
		
		if(area.owner.is_in_group("enemy")):
			current_state = STATE.IDLE
			near_enemy = true
			
		
	

func _on_Area2D_area_exited(area: Area2D) -> void:
	if current_state == STATE.DIED:
		pass
	elif area.owner && area.owner.is_in_group("player"):
		near_player = false
		#current_state = STATE.CHASE
		#attack_delay_timer.stop()
	if area.owner && area.owner.is_in_group("enemy"):
		near_enemy = false
		
	

func _on_Timer_timeout() -> void:
	if current_state == STATE.WAIT:
		current_state = STATE.ATTACK
	

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "attack":
		current_state = STATE.CHASE
	if anim_name == "hit":
		current_state = STATE.CHASE
		

func _on_TimerCharge_timeout():
	pass



func _on_FallCollision_area_entered(area):
	if area.owner.is_in_group("player"):
		if current_state == STATE.JUMP_FINISH && global_position.y == directionPlayer.y:
			attack()


func _on_AttackCollision_area_entered(area : Area2D):
	if area.owner.is_in_group("player"):
		if current_state == STATE.SPRINT:
			attack()
			
