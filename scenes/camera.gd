
extends Camera2D

var pos
var move
var diffx = 0
var diffy = 0
var direction
var roomsize
var speed = 16
const UP = Vector2(0,1)
const DOWN = Vector2(0,-1)
const LEFT = Vector2(1,0)
const RIGHT = Vector2(-1,0)

func _ready():
	roomsize = get_node("/root/game").gamesize
	set_process(true)

func _process(delta):
	if diffx > 0:
		set_pos(get_pos()+(direction*speed)) #muss noch mit delta gemacht werden
		diffx -= 1
		if diffx == 0:
			for p in get_tree().get_nodes_in_group("player"):
				p.set_pos(p.get_pos()+(direction*64))
				p.stop = false
	if diffy > 0:
		set_pos(get_pos()+(direction*speed)) #muss noch mit delta gemacht werden
		diffy -= 1
		if diffy == 0:
			for p in get_tree().get_nodes_in_group("player"):
				p.set_pos(p.get_pos()+(direction*64))
				p.stop = false

func moveTo(dir):
	direction = dir
	if(direction == UP || direction == DOWN):
		diffy = roomsize.y/speed
	else:
		diffx = roomsize.x/speed