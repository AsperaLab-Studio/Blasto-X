extends Node

export var asariBossName1 = ""
export var asariBossName2 = ""
export(float) var delay = 1.0

var asariBoss1: asariBoss
var asariBoss2: asariBoss
var timer = Timer.new()
var rng

func _ready():
	rng = RandomNumberGenerator.new()
	asariBoss1 = get_node(asariBossName1)
	asariBoss2 = get_node(asariBossName2)

	self.add_child(timer)
	timer.connect("timeout", self, "start")
	timer.wait_time = delay
	timer.one_shot = true
	timer.start()

func start():
	randomize()
	var choice = int(rand_range(0, 2))
	if choice == 0:
		asariBoss1.current_state = asariBoss1.STATE.JUMP
		asariBoss2.current_state = asariBoss2.STATE.SPRINT
	else:
		asariBoss1.current_state = asariBoss1.STATE.SPRINT
		asariBoss2.current_state = asariBoss2.STATE.JUMP

func choose_attack():
	randomize()
	var choice = int(rand_range(0, 2))
	if choice == 0:
		if asariBoss1.current_state == asariBoss1.STATE.IDLE:
			asariBoss1.current_state = asariBoss1.STATE.JUMP
		if asariBoss2.current_state == asariBoss2.STATE.IDLE:
			asariBoss2.current_state = asariBoss2.STATE.SPRINT
	else:
		if asariBoss1.current_state == asariBoss1.STATE.IDLE:
			asariBoss1.current_state = asariBoss1.STATE.SPRINT
		if asariBoss2.current_state == asariBoss2.STATE.IDLE:
			asariBoss2.current_state = asariBoss2.STATE.JUMP

#func choose_landing_boss1():
#	randomize()
#	var choice = int(rand_range(0, 2))
#	if choice == 0:
#		asariBoss1.current_state = asariBoss1.STATE.LANDING_ATTACK
#	else:
#		asariBoss1.current_state = asariBoss1.STATE.LANDING_POSITIONING
#
#func choose_landing_boss2():
#	randomize()
#	var choice = int(rand_range(0, 2))
#	if choice == 0:
#		asariBoss2.current_state = asariBoss2.STATE.LANDING_ATTACK
#	else:
#		asariBoss2.current_state = asariBoss2.STATE.LANDING_POSITIONING

func _on_asariBoss1_attackDone():
	asariBoss2.current_state = asariBoss2.STATE.LANDING
	asariBoss2.oneTime = false


func _on_asariBoss2_attackDone():
	asariBoss1.current_state = asariBoss1.STATE.LANDING
	asariBoss1.oneTime = false

func choose_where_to_land():
	randomize()
	var choice = int(rand_range(0, 4))

	match choice:
		0:
			if asariBoss1.didLandingAtk && asariBoss1.current_state == asariBoss1.STATE.LANDING:
				asariBoss1.targetPos = asariBoss1.landing_points[0]
			if asariBoss2.didLandingAtk && asariBoss2.current_state == asariBoss2.STATE.LANDING:
				asariBoss2.targetPos = asariBoss2.landing_points[2]
		1:
			if asariBoss1.didLandingAtk && asariBoss1.current_state == asariBoss1.STATE.LANDING:
				asariBoss1.targetPos = asariBoss1.landing_points[1]
			if asariBoss2.didLandingAtk && asariBoss2.current_state == asariBoss2.STATE.LANDING:
				asariBoss2.targetPos = asariBoss2.landing_points[3]
		2:
			if asariBoss1.didLandingAtk && asariBoss1.current_state == asariBoss1.STATE.LANDING:
				asariBoss1.targetPos = asariBoss1.landing_points[2]
			if asariBoss2.didLandingAtk && asariBoss2.current_state == asariBoss2.STATE.LANDING:
				asariBoss2.targetPos = asariBoss2.landing_points[0]
		3:
			if asariBoss1.didLandingAtk && asariBoss1.current_state == asariBoss1.STATE.LANDING:
				asariBoss1.targetPos = asariBoss1.landing_points[3]
			if asariBoss2.didLandingAtk && asariBoss2.current_state == asariBoss2.STATE.LANDING:
				asariBoss2.targetPos = asariBoss2.landing_points[1]
