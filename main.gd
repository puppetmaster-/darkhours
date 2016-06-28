
extends Node2D

func _ready():
	get_node("CanvasLayer/start/TextureButton").connect("released",self,"startGame")

func startGame():
	tools.gotoGame()
	

