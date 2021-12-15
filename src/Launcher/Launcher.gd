extends Node2D
class_name Launcher

const projectile = preload("res://src/Launcher/Projectile/ProjectileRigid.tscn")

onready var towerList = $TowerList
onready var towerSpawn = $Tower_Spawn
onready var launchDir = $Launch_Direction
onready var tween = $Tween
onready var launchMats = $Control/Launch_Mats
onready var towerMenu = $Control/Tower_Menu
onready var predictor = $Predictor
onready var chair = $Manning_Position


var currentTower
var cursorInZone = false
var manned = false

func _ready():
	rotation = get_position().angle() + PI / 2

func spawn_tower(TowerType):
	if currentTower == null:
		currentTower = projectile.instance()
		currentTower.get_node(@"Sprite").set_texture(load(towerList.get_tower(TowerType)))
		add_child(currentTower)
		currentTower.set_position(towerSpawn.get_position())


func fire(direction):
	currentTower.launch(direction)
	currentTower = null


#	var temp = global_transform
#	var scene = get_tree().current_scene
#	get_parent().remove_child(self)
#	scene.add_child(self)
#	global_transform = temp
#	set_physics_process(true)


func on_button_pressed(TowerType):
	spawn_tower(TowerType)


func aim_reticle():
	tween.interpolate_property(launchDir, 'position', 
			launchDir.get_position(), to_local(get_global_mouse_position()),
			abs((to_local(get_global_mouse_position()) - launchDir.get_position()).length() / 50), 
			0, 2)
	tween.start()
	


func predict_path(direction):
	predictor.predict({
#		"gravity_force" : 1
		"texture" : currentTower.get_node(@"Sprite").get_texture(),
		"collision" : currentTower.shape_owner_get_owner(currentTower.get_shape_owners()[0]).get_shape(),
		"sim_speed" : 2,
		"launch_position" : currentTower.get_position(),
		"velocity" : direction
	})


func launch_button(value):
	launchMats.set_visible(value)
	if value:
		launchMats.set_position(-launchDir.get_position())


func end_predict():
	predictor.end_predict()



func turnoff(object, key):
	print(object.get_modulate().a)
	print("FUCK")
	tween.stop(towerMenu)
