extends Building

const projectile_box = preload("res://src/Box Launcher/Projectile.tscn")

const building = preload("res://src/Launcher/Launcher.tscn")

onready var chair = $Manning_Position
onready var construction_timer = $Construction_Timer

var currently_building = false
var current_construction = null

func _ready():
	camera_pos = get_node("Camera_Position").get_position()


func build(item):
	if !currently_building:
		current_construction = building
		currently_building = true
		construction_timer.start()
#		change shader here


func enter_building(entered):
	if player == null:
		change_parent(entered, self)
		player = entered
		player.set_position(chair.get_position())
		player.set_mode(1)
		build(building)
		#open ui
		return true
	else: 
		return false


func exit_building():
	if player != null:
		change_parent(player, get_parent())
		player.set_mode(0)
		player.leave_building(self)
		player = null
		#close ui


func send_box():
	if currently_building:
		var new_box = projectile_box.instance()
		call_deferred("add_child", new_box)
		new_box.set_stored(current_construction)
		new_box.set_position($Box_Spawn.get_position())
#		remove shader
		new_box.set_linear_velocity(Vector2(40,-40))
		call_deferred("change_parent",new_box, get_parent())
		currently_building = false
		current_construction = null
