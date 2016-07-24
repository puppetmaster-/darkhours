
extends CanvasLayer

var fps
var obj
var cam_pos
var player_pos
var mouse_pos
var biom
var wall
var map
var mapSize = Vector2(19,11)
var mapCellSize

func _ready():
	fps = get_node("lbl_fps")
	obj = get_node("lbl_obj")
	cam_pos = get_node("lbl_camera_pos")
	player_pos = get_node("lbl_player_pos")
	mouse_pos = get_node("lbl_mouse_pos")
	biom = get_node("Control/lbl_biom/text")
	wall = get_node("Control/lbl_wall/text")
	map = get_node("map/TileMap")
	mapCellSize= map.get_cell_size().x
	set_process(true)

func _process(delta):
	#only for debug
	fps.set_text("fps:"+str(OS.get_frames_per_second()))
	obj.set_text("Object count:"+str(Performance.get_monitor(Performance.OBJECT_COUNT)))
	cam_pos.set_text(str(get_node("/root/game").camera.get_global_pos()))
	mouse_pos.set_text(str(get_node("/root/game").camera.get_global_mouse_pos()))
	var test = get_node("/root/game").player.get_global_pos().distance_to(get_node("/root/game").camera.get_global_mouse_pos())
	player_pos.set_text(str(test))
	biom.set_text(str(get_node("/root/game/nav/roomes/"+str(get_node("/root/game").player.world_coordinate.x)+"_"+str(get_node("/root/game").player.world_coordinate.y)).biom))
	wall.set_text(str(get_node("/root/game/nav/roomes/"+str(get_node("/root/game").player.world_coordinate.x)+"_"+str(get_node("/root/game").player.world_coordinate.y)).wall_pattern_nr))
	
func updateMap(direction):
	var _player = get_node("/root/game").player
	var _roomList = get_node("/root/game").getRoomList()
	
	if direction == Vector2(-1,0):
		#right
		map.set_pos(map.get_pos()-Vector2(-mapCellSize,0))
		var _pos = Vector2(_player.get_world_coordinate().x+(mapSize.x-1)/2,_player.get_world_coordinate().y-(mapSize.y-1)/2)
		for y in range(mapSize.y+1):
			map.set_cell(_pos.x,_pos.y+y,-1,false,false,false)
	elif direction == Vector2(1,0):
		#left
		map.set_pos(map.get_pos()-Vector2(mapCellSize,0))
		var _pos = Vector2(_player.get_world_coordinate().x-(mapSize.x-1)/2,_player.get_world_coordinate().y-(mapSize.y-1)/2)
		for y in range(mapSize.y+1):
			map.set_cell(_pos.x,_pos.y+y,-1,false,false,false)
	elif direction == Vector2(0,-1):
		#down
		map.set_pos(map.get_pos()-Vector2(0,-mapCellSize))
		var _pos = Vector2(_player.get_world_coordinate().x-(mapSize.x-1)/2,_player.get_world_coordinate().y+(mapSize.y-1)/2)
		for x in range(mapSize.x+1):
			map.set_cell(_pos.x+x,_pos.y,-1,false,false,false)
	elif direction == Vector2(0,1):
		#up
		map.set_pos(map.get_pos()-Vector2(0,mapCellSize))
		var _pos = Vector2(_player.get_world_coordinate().x-(mapSize.x-1)/2,_player.get_world_coordinate().y-(mapSize.y-1)/2)
		for x in range(mapSize.x+1):
			map.set_cell(_pos.x+x,_pos.y,-1,false,false,false)

	var _room = get_node("/root/game/nav/roomes/"+str(_player.get_world_coordinate().x)+"_"+str(_player.get_world_coordinate().y))
	
	#properties = {"pattern":0,"scale":Vector2(1,1),"biom":0}
	var _properties = _roomList[_player.get_world_coordinate()]
	map.set_cell(_player.get_world_coordinate().x,_player.get_world_coordinate().y,_properties["pattern"],_properties["scale"].x ==  -1,_properties["scale"].y ==  -1,false)
	
	
	
