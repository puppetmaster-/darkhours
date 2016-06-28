tool
extends Node2D

var floor_map
var wall_map

var wall_pattern 
var deko_pattern

var roomseed = 0.0
var roomsize = Vector2(1024,704)
var roomCoordinate
var biom
var floorTileNr

var tilesize = 64
var zoom_for_noise = 4

func _ready():
	if !get_node("/root/game") == null:
		roomsize = get_node("/root/game").gamesize

func generate_first_room(seed_value,coordinate):
	roomseed = seed_value
	roomCoordinate = coordinate
	seed(roomseed)
	init()
	generate_room()

func generate_room():
	clearAllMap()
	var tm = load("res://scenes/tilesets/wall_"+str(randi()%3)+".tres")
	wall_map.set_tileset(tm)
	#floorMap
	for x in range(roomsize.x/tilesize):
		for y in range(roomsize.y/tilesize):
			floor_map.set_cell(x,y,floorTileNr,randb(),randb(),randb())
	#wallMap
	for x in range(roomsize.x/tilesize):
		for y in range(roomsize.y/tilesize):
			var r = randf()
			var cellType = wall_pattern.get_cell(x,y)
			var isFlipx = wall_pattern.is_cell_x_flipped(x,y)
			var isFlipy = wall_pattern.is_cell_y_flipped(x,y)
			var isTransposed = wall_pattern.is_cell_transposed(x,y)
			if cellType != -1:
				wall_map.set_cell(x,y,cellType,isFlipx,isFlipy,isTransposed)
	
	#deko not implemented jet
	"""
	for x in range(roomsize.x/tilesize):
		for y in range(roomsize.y/tilesize):
			var r = randf()
			var cellType = deko_pattern.get_cell(x,y)
			if cellType != -1:
				wall_map.set_cell(x,y,cellType,false,false,false)
	"""
	var flip = [Vector2(1,1),Vector2(-1,1),Vector2(-1,-1),Vector2(1,-1)]
	scale(flip[randi()%4])

func clearAllMap():
	for x in range(roomsize.x/tilesize):
		for y in range(roomsize.y/tilesize):
			floor_map.set_cell(x,y,-1,false,false,false)
			wall_map.set_cell(x,y,-1,false,false,false)

func init():
	floor_map = get_node("tiles/floor")
	wall_map = get_node("tiles/wall")
	
	var count_wall_patterns = get_node("pattern/wall").get_child_count()
	
	wall_pattern = get_node("pattern/wall/"+str(randi()%count_wall_patterns))
	#deko_pattern = get_node("pattern/deko/"+str(randi()%3))
	
	print("Room [",roomCoordinate,"] seed [",roomseed,"] biom [",tools.noise(roomCoordinate,zoom_for_noise),"]")
	
	if(tools.noise(roomCoordinate,zoom_for_noise) <= 3.0/6):
		# floorTile 0-5 green
		floorTileNr = randi()%6
		biom = 0
	elif (tools.noise(roomCoordinate,zoom_for_noise) > 3.0/6 && tools.noise(roomCoordinate,zoom_for_noise) <= 4.0/6):
		# floorTile 6-9 mood
		floorTileNr = randi()%4+6
		biom = 4
	elif (tools.noise(roomCoordinate,zoom_for_noise) > 4.0/6 && tools.noise(roomCoordinate,zoom_for_noise) <= 4.1/6):
		# 10 snow
		floorTileNr = 10
		biom = 2
	elif (tools.noise(roomCoordinate,zoom_for_noise) > 4.1/6 && tools.noise(roomCoordinate,zoom_for_noise) <= 4.5/6):
		# floortile 11-15 grey
		floorTileNr = randi()%5+11
		biom = 2
	elif (tools.noise(roomCoordinate,zoom_for_noise) > 4.5/6 && tools.noise(roomCoordinate,zoom_for_noise) <= 5.2/6):
		# floortile 16-19 tile
		floorTileNr = randi()%4+16
		biom = 1
	else:
		# floortile 20-37 wood
		floorTileNr = randi()%18+20
		biom = 3

func randb():
	return randi()%2 == 1