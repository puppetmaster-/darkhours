
extends Node2D

var camera
var player
var rooms
var navigation

var time = 0
var room_node
var map
var coordinate = Vector2(0,0)
var room_list = {}
var gamesize = Vector2(1024,704)

func _ready():
	#no gravity
	Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, Vector2(0,0))
	player = get_node("nav/player")
	room_node = load("res://scenes/room.tscn")
	rooms = get_node("nav/roomes")
	map = get_node("gui/map/TileMap")
	navigation = get_node("nav")
	init_camera()
	start()
	drawWorld()
	set_process(true)
	set_fixed_process(true)

func _process(delta):
	if !player.stop:
		var diff = camera.get_global_pos()-player.get_global_pos()
		var x = abs(diff.x)
		var y = abs(diff.y)
		if x > gamesize.x/2:
			if diff.x > 0:
				player.stop = true
				player.set_world_coordinate(Vector2(-1,0))
				camera.moveTo(camera.RIGHT)
				updateMap(Vector2(-1,0))
			else:
				player.stop = true
				player.set_world_coordinate(Vector2(1,0))
				camera.moveTo(camera.LEFT)
				updateMap(Vector2(1,0))
			drawWorld()
		elif y >  gamesize.y/2:
			if diff.y > 0:
				player.stop = true
				player.set_world_coordinate(Vector2(0,-1))
				camera.moveTo(camera.DOWN)
				updateMap(Vector2(0,-1))
			else:
				player.stop = true
				player.set_world_coordinate(Vector2(0,1))
				camera.moveTo(camera.UP)
				updateMap(Vector2(0,1))
			drawWorld()

func drawWorld():
	var list1 = [Vector2(0,1),
		Vector2(0,-1),Vector2(1,0),
		Vector2(-1,0),Vector2(-1,-1),
		Vector2(1,1),Vector2(-1,1),
		Vector2(1,-1)]
	var list2 = [Vector2(0,gamesize.y),
		Vector2(0,-gamesize.y),
		Vector2(gamesize.x,0),
		Vector2(-gamesize.x,0),
		Vector2(-gamesize.x,-gamesize.y),
		Vector2(gamesize.x,gamesize.y),
		Vector2(-gamesize.x,gamesize.y),
		Vector2(gamesize.x,-gamesize.y)]
	for i in range(8):
		if(!room_exist(player.get_world_coordinate()+list1[i])):
			var tmp_room = get_room(player.get_world_coordinate()+list1[i])
			tmp_room.set_pos(player.get_world_pos()+list2[i])
			rooms.add_child(tmp_room)
	#delete room
	addRoomToList(player.get_world_coordinate())
	deleteRooms(player.get_world_coordinate())

func init_camera():
	camera = get_node("Camera2D")
	camera.set_limit(MARGIN_RIGHT,2147483647)
	camera.set_limit(MARGIN_BOTTOM,2147483647)
	camera.set_limit(MARGIN_LEFT,-2147483647)
	camera.set_limit(MARGIN_TOP,-2147483647)

func get_room(world_coordinate):
	var _room = room_node.instance()
	_room.set_name(str(world_coordinate.x)+"_"+str(world_coordinate.y))
	_room.generate_first_room(tools.vector2_to_seed(world_coordinate),world_coordinate)
	return _room

func room_exist(world_coordinate):
	return rooms.has_node(str(world_coordinate.x)+"_"+str(world_coordinate.y))

func deleteRooms(world_coordinate):
	var list1 = [
		Vector2(2,2),Vector2(-2,-2),
		Vector2(0,2),Vector2(0,-2),
		Vector2(2,0),Vector2(-2,0),
		Vector2(1,2),Vector2(1,-2),
		Vector2(-1,2),Vector2(-1,-2),
		Vector2(2,1),Vector2(-2,1),
		Vector2(2,-1),Vector2(-2,-1)
		]
	for i in range(14):
		var _room_coordinate = world_coordinate+list1[i]
		if room_exist(_room_coordinate):
			var roomToDelete = rooms.get_node(str(_room_coordinate.x)+"_"+str(_room_coordinate.y))
			rooms.remove_child(roomToDelete)
			roomToDelete.free()
			
	
	
func start():
	var tmp_room = get_room(player.get_world_coordinate())
	tmp_room.set_pos(player.get_world_pos())
	rooms.add_child(tmp_room)

func _fixed_process(delta):
	free_nodes()

func free_nodes():
	for freeNode in get_tree().get_nodes_in_group("free"):
		freeNode.free()

func getNavigation(from, to):
	var path = navigation.get_simple_path(from, to)
	if path.size() == 0:
		return null
	return path

func updateMap(direction):
	if direction == Vector2(-1,0):
		#right
		map.set_pos(map.get_pos()-Vector2(-16,0))
		for y in range(7):
			map.set_cell(player.get_world_coordinate().x+10,player.get_world_coordinate().y-y,-1,false,false,false)
			map.set_cell(player.get_world_coordinate().x+10,player.get_world_coordinate().y+y,-1,false,false,false)
	elif direction == Vector2(1,0):
		#left
		map.set_pos(map.get_pos()-Vector2(16,0))
		for y in range(7):
			map.set_cell(player.get_world_coordinate().x-10,player.get_world_coordinate().y-y,-1,false,false,false)
			map.set_cell(player.get_world_coordinate().x-10,player.get_world_coordinate().y+y,-1,false,false,false)
	elif direction == Vector2(0,-1):
		#down
		map.set_pos(map.get_pos()-Vector2(0,-16))
		for x in range(11):
			map.set_cell(player.get_world_coordinate().x-x,player.get_world_coordinate().y+6,-1,false,false,false)
			map.set_cell(player.get_world_coordinate().x+x,player.get_world_coordinate().y+6,-1,false,false,false)
	elif direction == Vector2(0,1):
		#up
		map.set_pos(map.get_pos()-Vector2(0,16))
		for x in range(11):
			map.set_cell(player.get_world_coordinate().x-x,player.get_world_coordinate().y-6,-1,false,false,false)
			map.set_cell(player.get_world_coordinate().x+x,player.get_world_coordinate().y-6,-1,false,false,false)

func addRoomToList(_room_coordinate):
	if room_exist(_room_coordinate):
		var tmpRoom= rooms.get_node(str(_room_coordinate.x)+"_"+str(_room_coordinate.y))
		room_list[_room_coordinate] = tmpRoom.biom