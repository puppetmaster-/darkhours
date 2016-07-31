
extends Node2D

func _ready():
	get_node("CanvasLayer/start/TextureButton").connect("released",self,"startGame")
	Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, Vector2(0,0))
	""" only testing
	for i in range(10):
		print(i,"new perlinValue = ",tools.moreNoise(Vector2(i,i),123456,0.5,4,0.5,2,Vector2(50,50)))
	"""

func startGame():
	tools.gotoGame()
	

