
tool
extends StaticBody2D

export(bool) var lightSwitch = false setget switchLight

func _ready():
	switchLight(lightSwitch)
	randomize()
	get_node("hit").set_rot(randf())

func switchLight(newValue):
	lightSwitch = newValue
	
	if !has_node("Light2D"):
		return
	if lightSwitch:
		get_node("Light2D").show()
	else:
		get_node("Light2D").hide()
