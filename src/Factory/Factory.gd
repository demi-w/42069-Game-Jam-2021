extends Building

const projectile_box = preload("res://src/Box Launcher/Projectile.tscn")

const launcher = preload("res://src/Launcher/Launcher.tscn")
const refinery = preload("res://src/Refinery/Refinery.tscn")
const laser_tower = preload("res://src/Tower/Laser Tower/Laser Tower.tscn")

onready var chair = $Manning_Position
onready var construction_timer = $Construction_Timer
onready var factory_ui = $CanvasLayer/Control
onready var animation = $Sprite/AnimationPlayer

var base_color = Color.white
var currently_building = false
var current_construction = null
var selected_construct = null


func _ready():
	camera_pos = get_node("Camera_Position").get_position()
	get_node("Sprite").material.set("shader_param/NEWCOLOR", base_color)





func build():
	if !currently_building && selected_construct != null:
		current_construction = selected_construct
		currently_building = true
		selected_construct = null
		construction_timer.start()
		animation.play("Build")


func stop_build():
	construction_timer.stop()
	animation.stop()
	get_node("Sprite").material.set("shader_param/NEWCOLOR",base_color)


func change_selected(construct):
	selected_construct = get_building(construct)
	get_node("Sprite").material.set("shader_param/NEWCOLOR", get_building_color(selected_construct))
	print(get_node("Sprite").material.get("shader_param/NEWCOLOR"))


func get_building(construct):
	match construct:
		"Refinery":
			return refinery
		"Launcher":
			return launcher
		"Laser Tower":
			return laser_tower


func get_building_color(building):
	if building != null:
		match building:
			refinery:
				return Color.yellow
			launcher:
				return Color.purple
			laser_tower:
				return Color.green


func enter_building(entered):
	if player == null:
		change_parent(entered, self)
		player = entered
		player.set_position(chair.get_position())
		player.set_mode(1)
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
		animation.stop()
		get_node("Sprite").material.set("shader_param/NEWCOLOR",base_color)
		currently_building = false
		current_construction = null





func _on_exception_area_entered(body):
	if body is Projectile:
		body.too_close = true


func _on_exception_area_exited(body):
	if body is Projectile:
		body.too_close = false
