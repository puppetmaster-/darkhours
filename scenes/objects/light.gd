
tool
extends RigidBody2D

export(bool) var lightSwitch = false setget switchLight
var timer

func _ready():
	switchLight(lightSwitch)
	randomize()
	get_node("hit").set_rot(randf())
	timer = get_node("Timer")
	timer.connect("timeout",self,"shootTimerTimeout")

func switchLight(newValue):
	lightSwitch = newValue
	
	if !has_node("Light2D"):
		return
	if lightSwitch:
		get_node("Light2D").show()
	else:
		get_node("Light2D").hide()

func hit():
	if get_node("Light2D").is_enabled():
		get_node("ani").play("hit")
		timer.start()

func shootTimerTimeout():
	set_mode(RigidBody2D.MODE_STATIC)