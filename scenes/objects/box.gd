
extends RigidBody2D

func _ready():
	pass

func hit():
	get_node("ani").play("hit")


