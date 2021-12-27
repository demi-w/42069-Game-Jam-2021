extends Building

const projectile_box = preload("res://src/Box Launcher/Projectile.tscn")

onready var chair = $Manning_Position
onready var construction_timer = $Construction_Timer
onready var factory_ui = $CanvasLayer/Control
onready var animation = $Sprite/AnimationPlayer
onready var scrap_label = $ScrapStuff/VBoxContainer/Scrap_Total
onready var construction_sound = $Sprite/Building_Sound

var base_color = Color.white
var currently_building = false
var current_construction = null
var selected_construct = null
var construct_start_velocity = Vector2(40,40)

func _ready():
	randomize()
	camera_pos = get_node("Camera_Position").get_position()
	get_node("Sprite").material.set("shader_param/NEWCOLOR1", base_color)
	scrap_label.set_text(str(GameData.scrap))


func _process(_delta):
	scrap_label.set_text(str(GameData.scrap))


func build():
	if !currently_building && selected_construct != null:
		if GameData.scrap >= TowerStuff.get_building_cost(selected_construct):
			GameData.scrap -= TowerStuff.get_building_cost(selected_construct)
			current_construction = selected_construct
			currently_building = true
			construction_timer.start()
			animation.play("Build")
			construction_sound.play()
			$Particles2D.set_emitting(true)
		else:
			get_node("Sprite").material.set("shader_param/NEWCOLOR1", Color.red)
			animation.play("Flash")
			selected_construct = null
			yield(get_node("Sprite/AnimationPlayer"),"animation_finished")
			get_node("Sprite").material.set("shader_param/opacity", 0)
			get_node("Sprite").material.set("shader_param/NEWCOLOR1", base_color)


func stop_build():
	if selected_construct != null && currently_building:
		construction_timer.stop()
		animation.stop()
		construction_sound.stop()
		GameData.scrap += TowerStuff.get_building_cost(selected_construct)
		get_node("Sprite").material.set("shader_param/NEWCOLOR1",base_color)
		selected_construct = null
		current_construction = null
		currently_building = false
		$Particles2D.set_emitting(false)


func change_selected(construct):
	if !currently_building:
		if construct != null:
			selected_construct = TowerStuff.get_building(construct)
			get_node("Sprite").material.set("shader_param/NEWCOLOR1", TowerStuff.get_building_color(selected_construct))


func enter_building(entered):
	if player == null:
		change_parent(entered, self)
		player = entered
		player.set_position(chair.get_position())
		player.set_mode(1)
		factory_ui.open()
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
		new_box.set_stored(current_construction)
		new_box.set_position($Box_Spawn.get_position())
		new_box.set_linear_velocity(construct_start_velocity.rotated((get_position().angle()+ PI/2)))
		new_box.set_angular_velocity(rand_range(-PI, PI))
		call_deferred("add_child", new_box)
		animation.stop()
		construction_sound.stop()
		get_node("Sprite").material.set("shader_param/NEWCOLOR1",base_color)
		new_box.show_behind_parent = true
		$Particles2D.set_emitting(false)
		selected_construct = null
		currently_building = false
		current_construction = null


func _on_exception_area_entered(body):
	if body is Projectile:
		body.too_close = true


func _on_exception_area_exited(body):
	if body is Projectile:
		body.too_close = false


func _on_body_exited(body):
	if body.get_parent() == self:
		call_deferred("change_parent", body, get_parent())
		body.show_behind_parent = false


func _on_scrap_entered(body):
	if body is Scrap:
		GameData.scrap += body.get_scrap_value()
		body.queue_free()
