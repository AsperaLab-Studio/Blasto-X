class_name Player
extends KinematicBody2D

signal update_healthbar
signal death

onready var collision_shape : CollisionShape2D = $HitBox/CollisionShape2D
onready var sprite: Sprite = $Sprite
onready var attack_collision: Area2D = $Pivot/AttackCollision
onready var pivot: Node2D = $Pivot
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var bullet = preload("res://scenes/Bullet.tscn")
onready var position2d: Position2D = $Pivot/Position2D
onready var go = get_parent().get_node("GUI/UI2/Go")
onready var state_label = $StateLabel
onready var invincibility_timer = $InvincibilityTimer
onready var invincible = false

export var debug_mode : bool

enum STATE {IDLE, MOVE, ATTACK, HIT, SHOOT, WIN, DIED}

export(int) var speed: int = 300
export(bool) var moving: bool = false
export(Vector2) var direction: = Vector2.ZERO
export(Vector2) var orientation: = Vector2.RIGHT

var current_state = STATE.IDLE
var sceneManager = null

export var collidings_areas = []

func _ready() -> void:
	anim_player.play("idle")
	sceneManager = get_parent().get_node("StageManager")
	

func _process(delta: float) -> void:
	
	direction = _get_direction()
	if direction.x:
		orientation.x = direction.x
	
	match current_state:
		STATE.IDLE:
			if Input.is_action_just_pressed("attack"):
				current_state = STATE.ATTACK
				
			if Input.is_action_just_pressed("shoot"):
				current_state = STATE.SHOOT
				
			if direction:
				current_state = STATE.MOVE
				
			else:
				anim_player.play("idle")
				
			
		STATE.ATTACK:
			anim_player.play("attack")
		STATE.HIT:
			anim_player.play("hit")
		STATE.SHOOT:
			anim_player.play("shoot")
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
				
			
		STATE.DIED:
			collision_shape.disabled = true
			anim_player.play("died")
			
		
	
	if debug_mode:
		state_label.text = str(global_position.x)
		
	

func attack():
	for area in collidings_areas:
		if area.owner.is_in_group("enemy"):
			var enemy = area.owner
			enemy.hit(1)
			
		
	

func shoot():
	var bullet_instance = bullet.instance()
	bullet_instance.direction = orientation
	owner.add_child(bullet_instance)
	bullet_instance.global_transform = position2d.global_transform
	

func pause():
	anim_player.stop()
	set_process(false)
	

func death():
	emit_signal("death")
	

func _get_direction() -> Vector2:
	var input_direction = Vector2()
	input_direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input_direction
	

func hit(dps):
	if invincible == false:
		if sceneManager.points > 0:
			sceneManager.points = sceneManager.points - 20
		sceneManager.hit += 1
		if current_state != STATE.HIT:
			var amount = 0
			current_state = STATE.HIT
			emit_signal("update_healthbar", dps)
		
	

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "attack":
		current_state = STATE.IDLE
	
	if anim_name == "shoot":
		current_state = STATE.IDLE
	
	if anim_name == "hit":
		current_state = STATE.IDLE
	

func _on_AttackCollision_area_entered(area: Area2D) -> void:
	collidings_areas.append(area)
	

func _on_AttackCollision_area_exited(area: Area2D) -> void:
	collidings_areas.erase(area)
	

func audioStop():
	var audio = get_node("GunSFX")
	audio.stop()
	

func audioPlay():
	var audio = get_node("GunSFX")
	audio.play()
	

func _on_AreaGo_area_entered(area: Area2D) -> void:
	if get_parent().get_node("StageManager/EnemiesContainer").get_child_count() == 0 && sceneManager.spawned == true:
		sceneManager.spawned = false
		
	
	if get_parent().get_node("StageManager/EnemiesContainer").get_child_count() == 0:
		sceneManager.current_stage = sceneManager.current_stage + 1
		sceneManager._select_stage(sceneManager.current_stage)
		go.visible = false
		
	

func _on_HealthBar_value_changed(value: float) -> void:
	if value == 0:
		current_state = STATE.DIED
	

func _on_InvincibilityTimer_timeout() -> void:
	invincible = false
	

func _on_AnimationPlayer_animation_started(anim_name: String) -> void:
	if anim_name == "hit":
		invincibility_timer.start(1)
		invincible = true
	
