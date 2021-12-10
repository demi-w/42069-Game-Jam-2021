extends Node2D
class_name Launcher

const projectilePhantom = preload("res://src/Launcher/Projectile/ProjectilePhantom.tscn")
const projectile = preload("res://src/Launcher/Projectile/ProjectileRigid.tscn")

onready var towerList = $TowerList
onready var towerSpawn = $Tower_Spawn
onready var camera = $Camera
onready var launchDir = $Launch_Direction
onready var tween = $Tween

var currentTower
var cursorInZone = false


func spawn_tower(TowerType):
	if currentTower == null:
		currentTower = projectile.instance()
		currentTower.get_node(@"Sprite").set_texture(load(towerList.get_tower(TowerType)))
		add_child(currentTower)
		currentTower.set_position(towerSpawn.get_position())


func fire(direction):
#	remove_child(camera)			#camera stuff is temporary, for testing
#	currentTower.add_child(camera)
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
			abs((to_local(get_global_mouse_position()) - launchDir.get_position()).length() / 100), 
			0, 2)
	tween.start()

func predict_path(direction):
	currentTower.predict()

