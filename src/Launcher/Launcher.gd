extends Node2D

const projectile = preload("res://src/Launcher/Projectile/ProjectileRigid.tscn")

onready var towerList = $TowerList
onready var towerSpawn = $Tower_Spawn
onready var camera = $Camera

var cursor = load("res://src/Launcher/TEMP/cursor.png")
var pointer = load("res://src/Launcher/TEMP/pointer.png")

var currentTower
var cursorInZone = false

func _input(event):
	if currentTower != null:
		
		if Input.is_action_pressed("ui_select"):
			currentTower.rotation = (get_global_mouse_position()-towerSpawn.get_global_position()).angle() - PI/2
		if Input.is_action_just_released("ui_select"):
			fire(-(get_global_mouse_position()-towerSpawn.get_global_position()))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if currentTower != null:
		if cursorInZone:
			currentTower.follow_cursor(true)
		else:
			currentTower.follow_cursor(false)

func spawn_tower(TowerType):
	if currentTower == null:
		currentTower = projectile.instance()
		currentTower.get_node(@"Sprite").set_texture(load(towerList.get_tower(TowerType)))
		towerSpawn.add_child(currentTower)

func fire(direction):
	remove_child(camera)
	currentTower.add_child(camera)
	currentTower.launch(direction)
	
	
	currentTower = null
	
	pass

#	var temp = global_transform
#	var scene = get_tree().current_scene
#	get_parent().remove_child(self)
#	scene.add_child(self)
#	global_transform = temp
#	set_physics_process(true)


func _on_Mouse_Area_mouse_entered():
	Input.set_custom_mouse_cursor(pointer)
	cursorInZone = true



func _on_Mouse_Area_mouse_exited():
	Input.set_custom_mouse_cursor(cursor)
	cursorInZone = false


func on_button_pressed(TowerType):
	spawn_tower(TowerType)
