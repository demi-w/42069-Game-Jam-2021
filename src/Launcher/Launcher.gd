extends Building
class_name Launcher


signal strength_changed(strength)
signal angle_changed(angle)


onready var projectile_spawn = $Barrel/Projectile_Spawn
onready var launch_pos_sprite = $Launch_Direction
onready var cannon = $Barrel
onready var tween = $Tween
onready var predictor = $Predictor
onready var chair = $Manning_Position
onready var launcher_ui = $CanvasLayer/LauncherUI

var current_projectile = null
var manned = false

#For aiming
var launch_pos = Vector2(0,-25)
#var min_strength = 25
#var max_strength = 50
#var strength_scroll = 1
#var strength_dir = 0
#var min_angle = -15 * PI / 16
#var max_angle = -PI / 16
#var angle_scroll = 2*PI / 180
#var angle_dir = 0

func _init():
	can_zoom = true
	

func _ready():
	rotation = get_position().angle() + PI / 2
	camera_pos = get_node("Camera_Position").get_position()


#func _update_strength_dir():
#	strength_dir = Input.get_action_strength("up") - Input.get_action_strength("down")
#
#
#func _update_angle_dir():
#	angle_dir = Input.get_action_strength("right") - Input.get_action_strength("left")


#func _set_strength():
#	if strength_dir != 0:
#		if strength_dir > 0:
#			if launch_pos.length() < max_strength:
#				return strength_scroll
#		elif strength_dir < 0:
#			if launch_pos.length() > min_strength:
#				return -strength_scroll
#	return 0
#
#
#func _set_angle():
#	if angle_dir != 0:
#		if angle_dir > 0:
#			if launch_pos.angle() < max_angle:
#				return angle_scroll
#		elif angle_dir < 0:
#			if launch_pos.angle() > min_angle:
#				return -angle_scroll
#	return 0
	
	
func _handle_aim():
#	_update_strength_dir()
#	_update_angle_dir()
#	var last_launch_pos = launch_pos
#	launch_pos = launch_pos.normalized()*(launch_pos.length()+_set_strength())
#	launch_pos = launch_pos.rotated(_set_angle())
#	if last_launch_pos.length() != launch_pos.length():
#		emit_signal("strength_changed", launch_pos.length())
#	if last_launch_pos.angle() != launch_pos.angle():
#		emit_signal("angle_changed",launch_pos.angle())
	launch_pos_sprite.set_position(launcher_ui.get_aim()+Vector2(0,-10))
	aim_barrel()


func fire(direction):
	if current_projectile != null:
		change_parent(current_projectile, self)
		current_projectile.launch(direction)
		current_projectile = null


#func on_button_pressed(TowerType):
#	spawn_tower(TowerType)


func aim_reticle():
	tween.interpolate_property(launch_pos, 'position', 
			launch_pos.get_position(), to_local(get_global_mouse_position()),
			abs((to_local(get_global_mouse_position()) - launch_pos.get_position()).length() / 50), 
			0, 2)
	tween.start()
	aim_barrel()


func aim_barrel():
	cannon.set_rotation((launch_pos_sprite.get_position()-cannon.get_position()).angle()+PI/2)


func predict_path(direction):
	if current_projectile != null:
		predictor.predict({
#			"gravity_force" : 1
			"texture" : current_projectile.get_node(@"Sprite").get_texture(),
			"texture_region" : current_projectile.get_node(@"Sprite").get_region_rect(),
			"texture_scale" : current_projectile.get_node(@"Sprite").get_scale(),
			"collision" : current_projectile.shape_owner_get_owner(current_projectile.get_shape_owners()[0]).get_shape(),
			"sim_speed" : 2,
#			"from_planet" : false,
			"launch_position" : to_local(current_projectile.get_global_position()),
			"velocity" : direction
		})


func end_predict():
	predictor.end_predict()


func store_item(body):
	if current_projectile == null:
		change_parent(body, projectile_spawn)
		current_projectile = body
		current_projectile.arm()
		position_projectile()
		return true
	else:
		return false


func position_projectile():
	if current_projectile != null:
		current_projectile.set_position(projectile_spawn.get_position()) 
		current_projectile.rotation = 0


func enter_building(entered):
	if player == null:
		change_parent(entered, self)
		manned = true
		launcher_ui.open()
		player = entered
		player.set_position(chair.get_position())
		player.set_rotation(0)
		player.set_mode(1)
		return true
	else: 
		return false


func exit_building():
	change_parent(player, get_parent())
	manned = false
	launcher_ui.close()
	player.leave_building(self)
	player.set_mode(0)
	player = null
