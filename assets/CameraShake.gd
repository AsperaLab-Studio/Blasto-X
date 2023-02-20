extends Camera2D

onready var player = get_parent()
onready var rnd = RandomNumberGenerator.new()

enum STATE {IDLE, MOVE, ATTACK, HIT, SHOOT, SHAKE, WIN, DIED}

func _ready():
	rnd.randomize()

func _process(delta):
	if player.current_state == STATE.SHAKE:
		apply_shake()
		player.shakeStrenght = lerp(player.shakeStrenght, 0, player.shakeDecayRate + delta)
		offset = get_random_offset()
	else:
		offset = player.defaultOffset
	

func apply_shake():
	player.shakeStrenght = player.randomShackeStrenght
	

func get_random_offset() -> Vector2:
	return Vector2(
		rnd.randf_range(-player.shakeStrenght, player.shakeStrenght),
		rnd.randf_range(-player.shakeStrenght, player.shakeStrenght)
	)
