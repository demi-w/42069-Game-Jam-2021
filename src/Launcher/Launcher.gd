extends Node2D
class_name Launcher

const projectile = preload("res://src/Launcher/Projectile/ProjectileRigid.tscn")

onready var towerList = $TowerList
onready var towerSpawn = $Tower_Spawn
onready var camera = $Camera
onready var launchDir = $Launch_Direction
onready var tween = $Tween
onready var launchMats = $Control/Launch_Mats
onready var towerMenu = $Control/Tower_Menu

var currentTower
var cursorInZone = false


func _ready():
	rotation = get_position().angle() + PI / 2

func spawn_tower(TowerType):
	if currentTower == null:
		currentTower = projectile.instance()
		currentTower.get_node(@"Sprite").set_texture(load(towerList.get_tower(TowerType)))
		add_child(currentTower)
		currentTower.set_position(towerSpawn.get_position())


func fire(direction):
	remove_child(camera)			#camera stuff is temporary, for testing
	currentTower.add_child(camera)
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
	currentTower.predict(direction)


func launch_button(value):
	launchMats.set_visible(value)
	if value:
		launchMats.set_position(-launchDir.get_position())


func end_predict():
	get_tree().call_group("Paths", "queue_free")


func build_menu(value):
	if value:
		towerMenu.set_visible(value)
		tween.stop(towerMenu)
		tween.interpolate_property(towerMenu, 'modulate:a',
				towerMenu.get_modulate().a, 1.0, 
				(1.0 - towerMenu.get_modulate().a) / .5)
		tween.start()
	else:
		tween.stop(towerMenu)
		tween.interpolate_property(towerMenu, 'modulate:a',
				towerMenu.get_modulate().a, 0.0, 
				abs(0 - towerMenu.get_modulate().a) / .5)
		tween.start()



func turnoff(object, key):
	print(object.get_modulate().a)
	print("FUCK")
	#tween.stop(towerMenu)
