extends Node2D

enum STATE {CHASE, ATTACK, TELEPORT_START, TELEPORT_MID_, TELEPORT_FINISH, CHARGE_START, CHARGE_MID, CHARGE_END, WAIT, IDLE, HIT, DIED}

var asari_boss_1 = get_child(1)
var asari_boss_2 = get_child(2)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _selectState():
	pass

func _selectAsari():
	pass
