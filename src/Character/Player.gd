extends RigidBody2D
class_name Player

onready var body = $Sprite

var snapvect = Vector2(0,4)
var normal = Vector2(0,-1)

var velocity = Vector2()
var gravity
var parent = get_parent()
var movDir = 0
var movSpeed = 20
var lastmovDir = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity = to_local(get_parent().get_position()).normalized() * 96
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func _update_movDir():
#	movDir = Input.get_action_strength("right") - Input.get_action_strength("left")
#
#
func _update_rotation():
	#set_rotation(get_position().angle() + PI / 2)
	pass
#
#
#func _apply_gravity(delta):
#	print(to_local(get_parent().get_position()).normalized() * 96)
#	gravity = to_local(get_parent().get_position()).normalized() * 96
#	velocity += gravity * delta
#
#
#func _apply_movement():
#	snapvect = gravity.normalized() * 16
#	velocity = move_and_slide_with_snap(velocity, snapvect, normal, true)
func _update_movDir():
	movDir = Input.get_action_strength("right") - Input.get_action_strength("left")

func _apply_gravity(delta):
	pass

func _handle_movement():
	pass

func _apply_movement():
	pass
	
