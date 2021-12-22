extends RigidBody2D
class_name Player

signal entered_building(player, building)
signal exited_building(player, building)

onready var sprite = $Sprite
onready var groundcast = $Groundcast
onready var carry_position = $Carry_Position
onready var interaction_timer = $Interaction_Timer
onready var e_button = $Interact_Button
onready var player_state_machine = $StateMachine
onready var f_button = $Throw_Sprite
onready var f_button2 = $Throw_Sprite2

var last_played = null

var interaction_list = []

var snapvect = Vector2(0,4)
var normal = Vector2(0,-1)

var velocity = Vector2()
var gravity
var parent = get_parent()
var movDir = 0
var movSpeed = 20
var lastmovDir = 1
var maxSpeed = 100
var lastPosition = Vector2()
var is_grounded
var held_item = null
var can_zoom = true

#For throwing
var launch_pos = Vector2(0,-10)
var min_strength = 10
var max_strength = 50
var strength_scroll = 1
var min_angle = -15 * PI / 16
var max_angle = -PI / 16
var angle_scroll = 2*PI / 180
var angle_dir = 1


func _update_rotation():
	set_rotation(get_position().angle() + PI / 2)


func _update_movDir():
	movDir = Input.get_action_strength("right") - Input.get_action_strength("left")


func _apply_gravity(_delta):
	pass #no


func _handle_movement():
	if get_linear_velocity().project(-get_position().tangent().normalized()).length() < maxSpeed:
		if movDir != 0:
			sprite.scale.x = movDir
			lastmovDir = movDir
			apply_central_impulse(-get_position().tangent().normalized() * movDir * movSpeed)
	is_grounded = groundcast.is_colliding()


func _handle_throw():
	launch_pos = launch_pos.normalized()*(launch_pos.length()+_set_strength())
	launch_pos = launch_pos.rotated(_set_angle())
	if launch_pos.x >= 0 :
		sprite.scale.x = 1
	else: 
		sprite.scale.x = -1
	$Launch_Direction.set_position(launch_pos+Vector2(0,-16))


func _update_angleDir():
	angle_dir = Input.get_action_strength("up") - Input.get_action_strength("down")


func _set_strength():
	if angle_dir != 0:
		if angle_dir > 0:
			if launch_pos.length() < max_strength:
				return strength_scroll
		elif angle_dir < 0:
			if launch_pos.length() > min_strength:
				return -strength_scroll
	return 0


func _set_angle():
	if movDir != 0:
		if movDir > 0:
			if launch_pos.angle() < max_angle:
				return angle_scroll
		elif movDir < 0:
			if launch_pos.angle() > min_angle:
				return -angle_scroll
	return 0


func _throw():
	if held_item != null:
		var raw_vel = $Launch_Direction.get_global_position()-held_item.get_global_position()
		if held_item is Projectile:
			held_item.armed = true
#			print($Launch_Direction.get_global_position())
			held_item.launch(4*(raw_vel), false)
			held_item = null
		elif held_item is Scrap:
			held_item.set_linear_velocity(4*(raw_vel))
			drop_item()
		set_linear_velocity(get_position().tangent().normalized()*raw_vel.length()*sprite.scale.x)


func get_vertical_direction():
	return lastPosition.length() - get_position().length()


func pickup_item(body):
	change_parent(body, self)
	held_item = body
	body.set_position(carry_position.get_position())
	if body is RigidBody2D:
		body.set_mode(MODE_STATIC)
	interaction_list.remove(interaction_list.find(body))
	e_button.set_visible(false)
	f_button.set_visible(true)


func drop_item():
	change_parent(held_item, get_parent())
	if held_item is RigidBody2D:
		held_item.set_mode(MODE_RIGID)
	held_item.set_linear_velocity(get_linear_velocity()+held_item.get_linear_velocity())
	held_item.apply_central_impulse(Vector2(0,20).rotated(get_position().angle()+PI/2))
	held_item = null
	f_button.set_visible(false)


func change_parent(changed = null, new_owner = null):
	if changed != null:
		var old_owner = changed.get_parent()
		if new_owner != old_owner:
			var temp = changed.global_transform
			old_owner.remove_child(changed)
			new_owner.add_child(changed)
			changed.global_transform = temp
#	print(changed, " / ", new_owner, " / ", old_owner)


func enter_building(building_node):
	if building_node.enter_building(self):
		emit_signal("entered_building", self, building_node)
		if interaction_list.find(building_node) != -1:
			interaction_list.remove(interaction_list.find(building_node))
		player_state_machine.set_state(player_state_machine.states.Manning)


func store_item(building):
	if building.store_item(held_item):
		held_item = null


func leave_building(building):
	player_state_machine.set_state(player_state_machine.states.Idle)
	emit_signal("exited_building", self, building)

