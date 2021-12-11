extends RigidBody2D
class_name Player

onready var body = $Sprite
onready var groundcast = $Groundcast

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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


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
			body.scale.x = movDir
			lastmovDir = movDir
			apply_central_impulse(-get_position().tangent().normalized() * movDir * movSpeed)
	
	is_grounded = groundcast.is_colliding()


func get_vertical_direction():
	return lastPosition.length() - get_position().length()
