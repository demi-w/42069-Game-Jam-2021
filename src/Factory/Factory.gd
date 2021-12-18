extends Building

const projectile_box = preload("res://src/Box Launcher/Projectile.tscn")

const building = preload("res://src/Refinery/Refinery.tscn")

onready var chair = $Manning_Position
onready var construction_timer = $Construction_Timer
onready var factory_ui = $CanvasLayer/Control

var currently_building = false
var current_construction = null


func _ready():
	camera_pos = get_node("Camera_Position").get_position()


func build(item):
	if !currently_building:
		current_construction = building
		currently_building = true
		construction_timer.start()


func enter_building(entered):
	if player == null:
		change_parent(entered, self)
		player = entered
		player.set_position(chair.get_position())
		player.set_mode(1)
		build(building)
		factory_ui.open()
		#open ui
		return true
	else: 
		return false


func exit_building():
	if player != null:
		factory_ui.close()
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
		new_box.set_linear_velocity(Vector2(40,-40).rotated(get_position().angle()+ PI/2))
		call_deferred("change_parent",new_box, get_parent())
		currently_building = false
		current_construction = null


func _on_exception_area_entered(body):
	if body is Projectile:
		body.too_close = true


func _on_exception_area_exited(body):
	if body is Projectile:
		body.too_close = false
