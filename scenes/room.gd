tool
extends Node2D

var floor_map
var wall_map
var furniture_map

var wall_pattern
var wall_pattern_nr 
var furniture_pattern

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
	#furniture
	if biom != 0 && biom != 2: #not garden
		for x in range(roomsize.x/tilesize):
			for y in range(roomsize.y/tilesize):
				var r = randf()
				var cellType = furniture_pattern.get_cell(x,y)
				var isFlipx = furniture_pattern.is_cell_x_flipped(x,y)
				var isFlipy = furniture_pattern.is_cell_y_flipped(x,y)
				var isTransposed = furniture_pattern.is_cell_transposed(x,y)
				if cellType != -1:
					if cellType < 6: #fix
						if randb():
							furniture_map.set_cell(x,y,randi()%2,isFlipx,isFlipy,isTransposed)
					elif cellType == 6: #chair 10-18
						furniture_map.set_cell(x,y,19,isFlipx,isFlipy,isTransposed)
					elif cellType > 6: #chair 10-18
						if randb():
							furniture_map.set_cell(x,y,12,isFlipx,isFlipy,isTransposed)
	
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
	furniture_map = get_node("tiles/furniture")
	
	var count_wall_patterns = get_node("pattern/wall").get_child_count()
	
	var wall_pattern_nr = randi()%count_wall_patterns
	wall_pattern = get_node("pattern/wall/"+str(wall_pattern_nr))
	furniture_pattern = get_node("pattern/furnitur/"+str(wall_pattern_nr))
	
	var tm = null
	var noise_value = tools.noise(roomCoordinate,zoom_for_noise)
	
	if noise_value <= 3.0/6:
		# floorTile 0-5 green
		floorTileNr = randi()%6
		tm = load("res://scenes/tilesets/wall_"+str(randi()%2+3)+".tres")
		biom = 0
	elif noise_value > 3.0/6 && noise_value <= 4.0/6:
		# floorTile 6-9 mood
		floorTileNr = randi()%4+6
		tm = load("res://scenes/tilesets/wall_"+str(randi()%2)+".tres")
		biom = 4
	elif noise_value > 4.0/6 && noise_value <= 4.1/6:
		# 10 snow
		floorTileNr = 10
		tm = load("res://scenes/tilesets/wall_"+str(randi()%2+3)+".tres")
		biom = 2
	elif noise_value > 4.1/6 && noise_value <= 4.5/6:
		# floortile 11-15 grey
		floorTileNr = randi()%5+11
		tm = load("res://scenes/tilesets/wall_"+str(randi()%2)+".tres")
		biom = 2
	elif noise_value > 4.5/6 && noise_value <= 5.2/6:
		# floortile 16-19 tile
		floorTileNr = randi()%4+16
		tm = load("res://scenes/tilesets/wall_"+str(randi()%2)+".tres")
		biom = 1
	else:
		# floortile 20-37 wood
		floorTileNr = randi()%18+20
		tm = load("res://scenes/tilesets/wall_"+str(randi()%2)+".tres")
		biom = 3
	
	print("Room [",roomCoordinate,"] seed [",roomseed,"] biom_noise [",noise_value,"] biom [", biom,"] floorTileNr [",floorTileNr,"]")
	
	wall_map.set_tileset(tm)

func randb():
	return randi()%2 == 1