
extends Node

const Simplex = preload("res://scripts/simplex.gd")

func seed_to_vector2(seedValue):
	var x = (seedValue >> 16) & 0x7FFF
	if seedValue & 0x80000000 != 0:
		x = -x
	var y = (seedValue) & 0x7FFF
	if seedValue & 0x8000 != 0:
		y = -y
	return Vector2(x,y)

func vector2_to_seed(vector2Value):
	var seedValue = ((int(abs(vector2Value.x)) & 0x7FFF) << 16 | (int(abs(vector2Value.y)) & 0x7FFF))
	if (vector2Value.x < 0):
		seedValue |= 0x80000000
	if (vector2Value.y < 0):
		seedValue |= 0x8000
	return seedValue

func noise(vec2,factor):
	var val = Simplex.simplex2(vec2.x/factor,vec2.y/factor)
	return noisValueToColorValue(val)

func noisValueToColorValue(val):
	print("noiseval was =",val)
	#val from -1 to 1
	if val < 0:
		return (1-abs(val))/2
	else:
		return (val/2)+0.5

func gotoGame():
	goto_scene("res://scenes/game.tscn")

func gotoMenu():
	goto_scene("res://main.tscn")

func goto_scene(path):
	get_tree().change_scene(path)