extends Camera2D

onready var player = get_parent()
onready var rnd = RandomNumberGenerator.new()

enum STATE {IDLE, MOVE, ATTACK, HIT, SHOOT, SHAKE, WIN, DIED}

var shaked: bool = false
var camera
var player2

func _ready():
	rnd.randomize()
	camera = self
	for tmpPlayer in get_parent().get_parent().get_children():
		if(tmpPlayer != player):
			player2 = tmpPlayer
			
		
	

func _process(delta):
	if player.boss:
		limit_right = 950
		if shaked == true:
			apply_shake()
			player.shakeStrenght = lerp(player.shakeStrenght, 0, player.shakeDecayRate + delta)
			offset = get_random_offset()
		else:
			offset = player.defaultOffset
	else:
		#var borderPositionX = global_position.x - size.x/2
		#if player2.global_position.x < borderPositionX:
			#qui va il codice per trascinare il player 2
			pass
		
	

func apply_shake():
	player.shakeStrenght = player.randomShackeStrenght
	

func get_random_offset() -> Vector2:
	return Vector2(
		rnd.randf_range(-player.shakeStrenght, player.shakeStrenght),
		rnd.randf_range(-player.shakeStrenght, player.shakeStrenght)
	)
