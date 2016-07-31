tool
extends EditorPlugin

var dock = null
var tileSize = 64

func _enter_tree():
	dock = preload("res://addons/tileset_dock/tileset_dock.tscn").instance()
	dock.get_node("VBoxContainer/PanelContainer/VBoxContainer/collisionPolygon").connect("pressed",self,"collisionPolygon")
	dock.get_node("VBoxContainer/PanelContainer/VBoxContainer/collisionShape").connect("pressed",self,"collisionShape")
	dock.get_node("VBoxContainer/PanelContainer/VBoxContainer/occluder").connect("pressed",self,"occluder")
	dock.get_node("VBoxContainer/PanelContainer/VBoxContainer/navigation").connect("pressed",self,"navigation")
	dock.get_node("VBoxContainer/HBoxContainer/tilesize").connect("text_changed",self,"tilesize")
	dock.get_node("VBoxContainer/HBoxContainer/tilesize").set_text(str(tileSize))
	add_control_to_dock( DOCK_SLOT_RIGHT_BL, dock )

func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()

func collisionPolygon():
	print("add/remove collisionPolygon")
	for n in get_selection().get_selected_nodes():
		if n.has_node("StaticBody2D"):
			n.remove_child(n.get_node("StaticBody2D"))
		var _node = StaticBody2D.new()
		_node.set_name("StaticBody2D")
		n.add_child(_node)
		_node.set_owner(n.get_parent())
		var _node2 = CollisionPolygon2D.new()
		_node2.set_polygon(getVector2ArrayFromSprite())
		_node2.set_name("CollisionPolygon2D")
		_node.add_child(_node2)
		_node2.set_owner(n.get_parent())

func collisionShape():
	print("add/remove collisionShape")
	for n in get_selection().get_selected_nodes():
		if n.has_node("StaticBody2D"):
			n.remove_child(n.get_node("StaticBody2D"))
		var _node = StaticBody2D.new()
		_node.set_name("StaticBody2D")
		n.add_child(_node)
		_node.set_owner(n.get_parent())
		var _node2 = CollisionShape2D.new()
		var _recShape = RectangleShape2D.new()
		_recShape.set_extents(Vector2(tileSize/2,tileSize/2))
		_node2.set_shape(_recShape)
		_node2.set_name("CollisionShape2D")
		_node.add_child(_node2)
		_node2.set_owner(n.get_parent())

func occluder():
	print("add/remove occluder")
	for n in get_selection().get_selected_nodes():
		if n.has_node("LightOccluder2D"):
			n.remove_child(n.get_node("LightOccluder2D"))
		var _node = LightOccluder2D.new()
		_node.set_occluder_polygon(getOccPolygon2D())
		_node.set_name("LightOccluder2D")
		n.add_child(_node)
		_node.set_owner(n.get_parent())
		
func navigation():
	print("add/remove navigation")
	for n in get_selection().get_selected_nodes():
		if n.has_node("NavigationPolygonInstance"):
			n.remove_child(n.get_node("NavigationPolygonInstance"))
		var _node = NavigationPolygonInstance.new()
		_node.set_navigation_polygon(getNavPolygon())
		_node.set_name("NavigationPolygonInstance")
		n.add_child(_node)
		_node.set_owner(n.get_parent())

func getVector2ArrayFromSprite():
	var _Array = []
	var _Vector2Array = Vector2Array(_Array)
	_Vector2Array.append(Vector2(-tileSize/2,-tileSize/2))
	_Vector2Array.append(Vector2(tileSize/2,-tileSize/2))
	_Vector2Array.append(Vector2(tileSize/2,tileSize/2))
	_Vector2Array.append(Vector2(-tileSize/2,tileSize/2))
	return _Vector2Array
	
func getNavPolygon():
	var _navPoly = NavigationPolygon.new()
	_navPoly.add_outline(getVector2ArrayFromSprite())
	_navPoly.add_polygon(IntArray([0, 1, 2, 3]))
	_navPoly.set_vertices(getVector2ArrayFromSprite())
	return _navPoly
	
func getOccPolygon2D():
	var _occPoly = OccluderPolygon2D.new()
	_occPoly.set_polygon(getVector2ArrayFromSprite())
	return _occPoly

func tilesize(newTileSize):
	print("set tilesize to: ", newTileSize)
	tileSize = int(newTileSize)