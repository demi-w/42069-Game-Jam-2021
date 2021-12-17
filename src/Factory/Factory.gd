extends Building

const projectile_box = preload("res://src/Box Launcher/Projectile.tscn")

onready var chair = $Manning_Position

var player = null

var currently_building = false


func _ready():
	camera_pos = get_node("Camera_Position").get_position()


func build(item):
	if !currently_building:
		pass
#		new_box.set_stored(item)
#		change shader here
		


func entered_building(entered):
	print("ran2")
	entered.set_position(chair.get_position)
	player = entered


func exited_building():
	player.exit_building()


func send_box():
	var new_box = projectile_box.instance()
	add_child(new_box)
