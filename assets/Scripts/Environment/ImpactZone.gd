class_name ImpactZone
extends Position2D

onready var timer: Timer = $Timer
onready var impactArea: Sprite = $Sprite
onready var collider: CollisionShape2D = $Area2D/CollisionShape2D
onready var anim_player: AnimationPlayer = $AnimationPlayer

export(int) var delay_explosion = 5

func _ready():
	timer.wait_time = delay_explosion

func explode():
	collider.disabled = false

func activate():
	impactArea.visible = true
	timer.start()

func _on_Timer_timeout():
	anim_player.play("explosion")
