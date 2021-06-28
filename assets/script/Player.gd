extends KinematicBody2D

onready var sprite: AnimatedSprite = $AnimatedSprite
onready var attack_collision: Area2D = $AttackCollision
export(int) var speed: int = 50
export(bool) var moving: bool = false
var direction: = Vector2.ZERO
