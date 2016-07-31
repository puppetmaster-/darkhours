
extends KinematicBody2D

var speed = 300
var stop = false
var world_coordinate
var world_pos
var roomsize

var gfx_stand
var gfx_hold
var gfx_shoot
var gfx_reload
var shootTimer
var reloadTimer
var canShoot = true
var canReload = true
var gun
var shootposition

var canFlashlight =true
var flashlightTimer

var bulletScn
var bulletSpeed = 800
var shootDir = Vector2(0,0)
export var ai = false
export var menu = false

var game
var path
var old_mouse_pos

func _ready():
	if !menu:
		game = get_node("/root/game")
		roomsize = get_node("/root/game").gamesize
		
		world_coordinate = Vector2(0,0)
		world_pos = Vector2(0,0)
		old_mouse_pos = get_node("/root/game/Camera2D").get_global_mouse_pos()
	else:
		old_mouse_pos = get_global_mouse_pos()
	
	gfx_shoot = get_node("gfx/arm_right")
	
	gun = get_node("gfx/arm_right/gun")
	shootposition = gun.get_node("Position2D")
	
	shootTimer = get_node("shootTimer")
	shootTimer.connect("timeout",self,"shootTimerTimeout")
	reloadTimer = get_node("reloadTimer")
	reloadTimer.connect("timeout",self,"reloadTimerTimeout")
	flashlightTimer = get_node("gfx/arm_left/flashlight/flashlightTimer")
	flashlightTimer.connect("timeout",self,"flashlightTimerTimeout")
	
	bulletScn = load("res://scenes/bullet/bullet.tscn")
	set_fixed_process(true)

func _fixed_process(delta):
	if !stop:
		if !ai:
			var direction = Vector2(0,0)
			
			if ( Input.is_action_pressed("ui_up") ):
				direction += Vector2(0,-1)
			if ( Input.is_action_pressed("ui_down") ):
				direction += Vector2(0,1)
			if ( Input.is_action_pressed("ui_left") ):
				direction += Vector2(-1,0)
			if ( Input.is_action_pressed("ui_right") ):
				direction += Vector2(1,0)
			if ( Input.is_action_pressed("jump") ):
				get_node("jump").play("jump")
			if ( Input.is_action_pressed("shoot") ):
				if canShoot && canReload:
					shoot()
			"""
			if ( Input.is_action_pressed("reload") ):
				if canReload:
					reload()
			"""
			if ( Input.is_action_pressed("flashlight") ):
				if canFlashlight:
					switchFlashlight()
			
			#rotate the vector to move in direction
			if !menu:
				direction = direction.rotated(get_rot()-deg2rad(90))
			else:
				direction = direction.rotated(get_rot()+deg2rad(90))
		
			var velocity = direction * speed
			var motion = velocity * delta
			motion = move(motion)
			
			if (is_colliding()):
				var n = get_collision_normal()
				motion = n.slide(motion)
				velocity = n.slide(velocity)
				move(motion)
			
			var mousePos
			var specialRot
			
			if !menu:
				mousePos = get_node("/root/game/Camera2D").get_global_mouse_pos()
				specialRot = deg2rad(90)
			else:
				mousePos = get_global_mouse_pos()
				specialRot = -deg2rad(90)
				
			var isDistanceToPlayerOK = get_global_pos().distance_to(mousePos) > 30.0
			var hasMouseNewPosition = old_mouse_pos.distance_to(mousePos) > 0.5
		
			if  isDistanceToPlayerOK && hasMouseNewPosition:
				set_rot( get_global_pos().angle_to_point(mousePos) + specialRot)
			old_mouse_pos = mousePos

func get_world_coordinate():
	return world_coordinate

func get_world_pos():
	return world_pos

func set_world_coordinate(position_to_add):
	world_coordinate += position_to_add
	world_pos.x = world_pos.x + (position_to_add.x*roomsize.x)
	world_pos.y = world_pos.y + (position_to_add.y*roomsize.y)

func shoot():
	if !menu:
		var _mousePos = get_node("/root/game/Camera2D").get_global_mouse_pos()
		shootDir = (_mousePos - gun.get_global_pos()).normalized()
		var bullet = bulletScn.instance()
		bullet.set_global_pos(shootposition.get_global_pos())
		bullet.setVelocity(shootDir * Vector2(bulletSpeed,bulletSpeed))
		get_node("/root/game/objects").add_child(bullet)
		shootTimer.start()
		gfx_shoot.show()
		soundfx.play("shot"+str(randi()%4))
		canShoot = false

func reload():
	gfx_reload.show()
	reloadTimer.start()
	canReload = false

func shootTimerTimeout():
	gfx_shoot.hide()
	canShoot = true

func reloadTimerTimeout():
	gfx_reload.hide()
	gfx_stand.show()
	canReload = true

func switchFlashlight():
	flashlightTimer.start()
	canFlashlight = false
	if get_node("gfx/arm_left/flashlight/Light2D1").is_enabled():
		get_node("gfx/arm_left/flashlight/Light2D1").set_enabled(false)
		get_node("gfx/arm_left/flashlight/Light2D2").set_enabled(false)
	else:
		get_node("gfx/arm_left/flashlight/Light2D1").set_enabled(true)
		get_node("gfx/arm_left/flashlight/Light2D2").set_enabled(true)

func flashlightTimerTimeout():
	canFlashlight = true
	