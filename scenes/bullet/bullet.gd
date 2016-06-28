
extends RigidBody2D

var velocity
var timer
var speed = 1.2
var start = false

func _ready():
	timer = get_node("Timer")
	timer.connect("timeout",self,"onTimeout")
	get_node("Area2D").connect("body_enter",self,"onBodyEnter")
	set_fixed_process(true)

func _fixed_process(delta):
	if start:
		set_linear_velocity(velocity*speed)
		start = false
		speed = 1
	else:
		var x = get_linear_velocity().x
		var y = get_linear_velocity().y
		var currentVel = Vector2(x,y)
		set_linear_velocity(currentVel*speed)
		#move(velocity * Vector2(delta,delta))

func setVelocity(newVelocity):
	velocity = newVelocity
	start = true

func onTimeout():
	remove()

func remove():
	timer.stop()
	remove_from_group("bullet")
	add_to_group("free")
	hide()
	set_layer_mask(0) #layer
	set_collision_mask(0) #mask

func onBodyEnter(body):
	if(body.is_in_group("wall")):
		velocity = Vector2(0,0)
		speed = 0
		get_node("Particles2D").set_emitting(false)
		set_collision_mask(0)
		set_layer_mask(0)
	if(body.is_in_group("object")):
		hide()
		body.get_node("ani").play("hit")
		velocity = Vector2(0,0)
		speed = 0
		set_collision_mask(0)
		set_layer_mask(0)
		get_node("Particles2D").set_emitting(false)
