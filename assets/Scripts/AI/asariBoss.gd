class_name asariBoss
extends KinematicBody2D

signal attackDone

onready var sprite: Sprite = $Sprite
onready var pivot: Node2D = $Pivot
onready var attack_delay_timer: Timer = $AttackDelayTimer
onready var anim_player : AnimationPlayer = $AnimationPlayer
onready var collision_shape : CollisionShape2D = $HitBox/CollisionShape2D
onready var collision_shape_body : CollisionShape2D = $CollisionShape2D
onready var collition_area2d : CollisionShape2D = $Pivot/AttackCollision/CollisionShape2D

enum STATE {ATTACK, JUMP, LANDING, SPRINT, IDLE, HIT, DIED}

export(int) var death_speed := 150
export(int) var moving_speed := 50
export(int) var sprint_speed := 250
export(float) var jump_speed := 500.0
export(float) var fall_speed := 500.0
export(int) var dpsSprint := 15
export(int) var dpsLanding := 20
export(int) var HP := 5
export(float) var ChargeDeelay := 5.0
export(float) var SprintDistance := 200.0
export var HealthBarName = ""
export var wait_time_attack := 3

var current_state = STATE.IDLE
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

var targetPos: Vector2
var oneTime = false

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

func _process(_delta: float) -> void:
	actual_target = select_target()
	
	if(!paused):

		match current_state:
			STATE.IDLE:  #next state -> JUMP
				if anim_player.current_animation != "idle":
					anim_player.play("idle")
		
			STATE.HIT:
				anim_player.play("hit")

			STATE.ATTACK:
				anim_player.play("attack")	

				if anim_player.current_animation != "attack":
					emit_signal("attackDone")
					current_state = STATE.JUMP

			STATE.JUMP: #jump and choose what attack to do
				if oneTime == false:
					anim_player.play("Jump")
					has_sprinted = true
					targetPos = Vector2(global_position.x, (global_position.y - 8000))
					collision_shape_body.disabled = true
					oneTime = true
				if sprite.frame == 8:
					jumping()
				if global_position == targetPos:
					current_state = STATE.IDLE
			
			STATE.LANDING: #move toward the target (downwards) | next state -> WAIT
				anim_player.play("Falling")

				move_towards(Vector2(global_position.x, directionPlayer.y), fall_speed)
			
			STATE.SPRINT: #set the target direction and teleport next to it (x axis)  | next state -> SPRINT END
				if oneTime == false:
					actual_dps = dpsSprint
					
					directionPlayer = actual_target.global_position
					
					anim_player.play("Sprint")
					oneTime = true

				move_towards(directionPlayer, sprint_speed)
					
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
	if (current_state != STATE.JUMP && current_state != STATE.SPRINT):
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


func jumping() -> void:
	move_towards(targetPos, jump_speed)

func falling() -> void:
	actual_dps = dpsLanding
	collision_shape_body.disabled = true
	var targetPositionStamp = Vector2()
	targetPositionStamp.y = actual_target.position.y
	directionPlayer = targetPositionStamp

func choose_array_numb(array):
	return array[randi() % array.size()]

# func _on_asariBoss_CallSprint():
# 	if directionPlayer.x < 660:
# 		sprint_direction = 1
# 	elif directionPlayer.x > 660:
# 		sprint_direction = -1

# func _on_asariBoss2_CallSprint():
# 	if directionPlayer.x > 210:
# 		sprint_direction = -1
# 	elif directionPlayer.x < 210:
# 		sprint_direction = 1

func _on_FallCollision_area_entered(area): #impact area when landing after falling attack
	if area.owner.is_in_group("player"):
		if (current_state == STATE.LANDING && global_position.y == directionPlayer.y && 
			anim_player.current_animation == "Landing"):
			attack()

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "Falling":
		falling()

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "hit":
		current_state = STATE.IDLE
	if anim_name == "Falling":
		collision_shape_body.disabled = false
		current_state = STATE.IDLE
	if anim_name == "Sprint":
		pass
	if anim_name == "attack":
		current_state = STATE.IDLE

func _on_AttackCollision_area_entered(area):
	if area.owner.is_in_group("player"):
		current_state = STATE.ATTACK
