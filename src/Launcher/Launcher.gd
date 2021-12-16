extends Node2D
class_name Launcher

const projectile = preload("res://src/Launcher/Projectile/ProjectileRigid.tscn")


onready var projectile_spawn = $Projectile_Spawn
onready var launchDir = $Launch_Direction
onready var tween = $Tween
onready var launchMats = $Control/Launch_Mats
onready var predictor = $Predictor
onready var chair = $Manning_Position
onready var camera_pos = $Camera_Position

var current_projectile = null
var cursorInZone = false
var manned = false

func _ready():
	rotation = get_position().angle() + PI / 2


func fire(direction):
	current_projectile.launch(direction)
	current_projectile = null


#	var temp = global_transform
#	var scene = get_tree().current_scene
#	get_parent().remove_child(self)
#	scene.add_child(self)
#	global_transform = temp
#	set_physics_process(true)


#func on_button_pressed(TowerType):
#	spawn_tower(TowerType)


func aim_reticle():
	tween.interpolate_property(launchDir, 'position', 
			launchDir.get_position(), to_local(get_global_mouse_position()),
			abs((to_local(get_global_mouse_position()) - launchDir.get_position()).length() / 50), 
			0, 2)
	tween.start()
	


func predict_path(direction):
	predictor.predict({
#		"gravity_force" : 1
#		"texture" : current_projectile.get_node(@"Sprite").get_texture(),
#		"collision" : current_projectile.shape_owner_get_owner(currentTower.get_shape_owners()[0]).get_shape(),
		"sim_speed" : 2,
		"from_planet" : false,
		"launch_position" : current_projectile.get_position(),
		"velocity" : direction
	})


func launch_button(value):
	launchMats.set_visible(value)
	if value:
		launchMats.set_position(-launchDir.get_position())


func end_predict():
	predictor.end_predict()


func change_parent(changed = null, new_owner = null, old_owner = null):
	if changed != null:
		var temp = changed.global_transform
		old_owner.remove_child(changed)
		new_owner.add_child(changed)
		changed.global_transform = temp


func store_projectile(body):
	current_projectile = body
	current_projectile.arm()
	position_projectile()


func position_projectile():
	if current_projectile != null:
		current_projectile.set_position(projectile_spawn.get_position()) 
