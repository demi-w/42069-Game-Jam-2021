extends RigidBody2D
class_name Player

onready var sprite = $Sprite
onready var groundcast = $Groundcast
onready var carry_position = $Carry_Position
onready var interaction_timer = $Interaction_Timer

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _update_rotation():
	set_rotation(get_position().angle() + PI / 2)


func _update_movDir():
	movDir = Input.get_action_strength("right") - Input.get_action_strength("left")


func _apply_gravity(delta):
	pass #no


func _handle_movement():
	if get_linear_velocity().project(-get_position().tangent().normalized()).length() < maxSpeed:
		if movDir != 0:
			sprite.scale.x = movDir
			lastmovDir = movDir
			apply_central_impulse(-get_position().tangent().normalized() * movDir * movSpeed)
	is_grounded = groundcast.is_colliding()


func get_vertical_direction():
	return lastPosition.length() - get_position().length()

func pickup_item(body):
	change_parent(body, self, body.get_parent())
	body.set_position(carry_position.get_position())
	body.set_collision_layer(0)
	if body is RigidBody2D:
		body.set_mode(MODE_STATIC)
	held_item = body

func drop_item():
	change_parent(held_item, get_parent(), self)
	if held_item is RigidBody2D:
		held_item.set_mode(MODE_RIGID)
	held_item.set_collision_layer(32)
	held_item = null

func change_parent(changed = null, new_owner = null, old_owner = null):
	if changed != null:
		var temp = changed.global_transform
		old_owner.remove_child(changed)
		new_owner.add_child(changed)
		changed.global_transform = temp
#	print(changed, " / ", new_owner, " / ", old_owner)

func enter_building(building):
	change_parent(self, building.get_parent(), get_parent())
	set_mode(1)
	set_position(get_parent().chair.position)
	print(get_global_rotation())
	print(get_position().angle()+PI/2)
	set_rotation(to_local(get_position()).angle()-PI/2)
	print(get_position())
	get_parent().manned = true

func leave_building():
	get_parent().manned = false
	change_parent(self, get_parent().get_parent(), get_parent())
	set_mode(0)
	
