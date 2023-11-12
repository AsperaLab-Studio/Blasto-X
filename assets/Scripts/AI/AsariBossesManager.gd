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



func _on_asariBoss1_attackDone():
	asariBoss2.current_state = asariBoss2.STATE.LANDING
	asariBoss2.oneTime = false


func _on_asariBoss2_attackDone():
	asariBoss1.current_state = asariBoss1.STATE.LANDING
	asariBoss1.oneTime = false

func choose_where_to_land():
	randomize()
	var choice = int(rand_range(0, 4))
	if choice == 0:
		asariBoss1.targetPos = asariBoss1.landing_point_1
		asariBoss2.targetPos = asariBoss2.landing_point_3
	if choice == 1:
		asariBoss1.targetPos = asariBoss1.landing_point_2
		asariBoss2.targetPos = asariBoss2.landing_point_4
	if choice == 2:
		asariBoss1.targetPos = asariBoss1.landing_point_3
		asariBoss2.targetPos = asariBoss2.landing_point_1
	if choice == 3:
		asariBoss1.targetPos = asariBoss1.landing_point_4
		asariBoss2.targetPos = asariBoss2.landing_point_2
