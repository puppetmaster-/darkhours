
extends Node2D

var cursor
var isMouseMoving = true
export(bool) var gui = false

func _ready():
	if gui:
		cursor = get_node("cursor/gui")
		get_node("cursor/shoot").hide()
	else:
		cursor = get_node("cursor/shoot")
		get_node("cursor/gui").hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_process_input(true)
	set_process(true)

func _process(delta):
	if isMouseMoving:
		var _mousePos = get_node("/root/game/Camera2D").get_global_mouse_pos()
		cursor.set_pos(_mousePos)

func _input(event):
	if (event.type == InputEvent.MOUSE_MOTION):
		isMouseMoving = true
	else:
		isMouseMoving = false


