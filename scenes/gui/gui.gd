
extends CanvasLayer

var fps
var obj
var cam_pos
var player_pos
var mouse_pos
var biom
var wall

func _ready():
	fps = get_node("lbl_fps")
	obj = get_node("lbl_obj")
	cam_pos = get_node("lbl_camera_pos")
	player_pos = get_node("lbl_player_pos")
	mouse_pos = get_node("lbl_mouse_pos")
	biom = get_node("Control/lbl_biom/text")
	wall = get_node("Control/lbl_wall/text")
	set_process(true)

func _process(delta):
	fps.set_text("fps:"+str(OS.get_frames_per_second()))
	obj.set_text("Object count:"+str(Performance.get_monitor(Performance.OBJECT_COUNT)))
	cam_pos.set_text(str(get_node("/root/game").camera.get_global_pos()))
	mouse_pos.set_text(str(get_node("/root/game").camera.get_global_mouse_pos()))
	var test = get_node("/root/game").player.get_global_pos().distance_to(get_node("/root/game").camera.get_global_mouse_pos())
	player_pos.set_text(str(test))
	biom.set_text(str(get_node("/root/game/nav/roomes/"+str(get_node("/root/game").player.world_coordinate.x)+"_"+str(get_node("/root/game").player.world_coordinate.y)).biom))
	wall.set_text(str(get_node("/root/game/nav/roomes/"+str(get_node("/root/game").player.world_coordinate.x)+"_"+str(get_node("/root/game").player.world_coordinate.y)).wall_pattern_nr))
	

