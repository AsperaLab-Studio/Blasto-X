class_name asariBoss
extends KinematicBody2D

signal CallSprint

onready var sprite: Sprite = $Sprite
onready var pivot: Node2D = $Pivot
onready var attack_delay_timer: Timer = $AttackDelayTimer
onready var anim_player : AnimationPlayer = $AnimationPlayer
onready var collision_shape : CollisionShape2D = $HitBox/CollisionShape2D
onready var collision_shape_body : CollisionShape2D = $CollisionShape2D
onready var collition_area2d : CollisionShape2D = $Pivot/AttackCollision/CollisionShape2D

enum STATE {JUMP, LANDING_START, LANDING_END, SPRINT_START, SPRINT_END, WAIT, HIT, DIED}

export(int) var death_speed := 150
export(int) var moving_speed := 50
export(int) var charge_speed := 100
export(float) var jump_speed := 50
export(float) var fall_speed := 50
export(int) var dpsSprint := 15
export(int) var dpsLanding := 20
export(int) var HP := 5
export(float) var ChargeDeelay := 5.0
export(float) var SprintDistance := 500.0
export var HealthBarName = ""
export var wait_time_attack := 3

var current_state = STATE.JUMP
var actual_target: Player = null
var directionPlayer = Vector2()
var near_player: bool = false
var near_enemy: bool = false
var healthBar = null
var amount = 0
var paused = false
var areaCollided = null
var targetList = null
var actual_dps = dpsSprint
var has_sprinted : bool = false
var sprint_direction = 1

var rng

var UIHealthBar: Node2D 
var chargeFree: bool = false

var sceneManager = null

func _ready():
	rng = RandomNumberGenerator.new()
	UIHealthBar = get_parent().get_parent().get_parent().get_node(HealthBarName)
	anim_player.play("idle")
	healthBar = UIHealthBar
	
	sceneManager = get_parent().get_parent()
	attack_delay_timer.wait_time = wait_time_attack

func _process(_delta: float) -> void:
	actual_target = select_target()
	
	if(!paused):

		match current_state:
			STATE.HIT:
				anim_player.play("hit")
				
			STATE.WAIT:
				if near_player:
					if anim_player.current_animation != "idle":
						anim_player.play("idle")
					if attack_delay_timer.is_stopped():
						attack_delay_timer.wait_time = wait_time_attack
						attack_delay_timer.start()
				if !near_player:
					current_state = STATE.JUMP
					
			STATE.JUMP:
				if anim_player.current_animation != "Jump":
					anim_player.play("Jump")
				has_sprinted = false
			
			STATE.LANDING_START:
				directionPlayer = actual_target.position
				global_position = (Vector2(directionPlayer.x, global_position.y))
				
				current_state = STATE.LANDING_END
			
			STATE.LANDING_END:
				if anim_player.current_animation != "Falling":
					anim_player.play("Falling")
				move_towards(Vector2(global_position.x, directionPlayer.y), fall_speed)
				if global_position == Vector2(global_position.x, directionPlayer.y) && anim_player.current_animation != "Landing":
					anim_player.play("Landing")
			
			STATE.SPRINT_START:
				actual_dps = dpsSprint
				global_position = Vector2((actual_target.position.x + SprintDistance * sprint_direction), actual_target.position.y)
				directionPlayer = Vector2((actual_target.position.x), (actual_target.position.y))
				
				current_state = STATE.SPRINT_END
			
			STATE.SPRINT_END:
				move_towards(directionPlayer, charge_speed)
				if anim_player.current_animation != "Sprint":
					anim_player.play("Sprint")
				if global_position == directionPlayer && anim_player.current_animation != "attack":
					anim_player.play("attack")
			
			STATE.DIED:
				collision_shape_body.disabled = true
				collision_shape.disabled = true
				
				collition_area2d.disabled = true
				
				anim_player.play("died")
				
				var directionDead = Vector2((global_position.x - actual_target.position.x), 0).normalized()
				
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
	
func move_towards(target: Vector2, speed):
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
	

func _on_Area2D_area_exited(area: Area2D) -> void:
	if current_state == STATE.DIED:
		pass
	elif area.owner && area.owner.is_in_group("player"):
		near_player = false
	if area.owner && area.owner.is_in_group("enemy"):
		near_enemy = false

func _on_Timer_timeout() -> void:
	if current_state == STATE.WAIT:
		current_state = STATE.JUMP
	
func _on_TimerCharge_timeout():
	pass

func choose_array_numb(array):
	return array[randi() % array.size()]

func _on_asariBoss_CallSprint():
	sprint_direction = 1
	StateToSprint()

func _on_asariBoss2_CallSprint():
	sprint_direction = -1
	StateToSprint()

func _on_FallCollision_area_entered(area):
	if area.owner.is_in_group("player"):
		if current_state == STATE.LANDING_END && global_position.y == directionPlayer.y && anim_player.current_animation == "Landing":
			attack()


func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "Falling":
		falling()

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "hit":
		current_state = STATE.WAIT
	if anim_name == "Jump":
		jumping()
	if anim_name == "Landing":
		collision_shape.disabled = false
		current_state = STATE.WAIT
	if anim_name == "Sprint":
		has_sprinted = true
		emit_signal("CallSprint")
	if anim_name == "attack" && current_state == STATE.SPRINT_END:
		current_state = STATE.WAIT

func StateToSprint():
	if has_sprinted == false:
		current_state = STATE.SPRINT_START

func jumping() -> void:
	global_position = Vector2(global_position.x, global_position.y - 800)
	randomize()
	var temp = int(rand_range(0, 2))
	if temp == 0:
		current_state = STATE.SPRINT_START
	elif temp == 1:
		current_state = STATE.LANDING_START

func falling() -> void:
	actual_dps = dpsLanding
	collision_shape.disabled = true
	var targetPositionStamp = Vector2()
	targetPositionStamp.y = actual_target.position.y
	directionPlayer = targetPositionStamp
