extends KinematicBody2D
class_name Player

onready var body = $Sprite

var snapvect = Vector2(0,4)
var normal = Vector2(0,-1)

var velocity = Vector2()
var gravity
var parent = get_parent()
var movDir
var movSpeed = 200
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _update_movDir():
	movDir = Input.get_action_strength("right") - Input.get_action_strength("left")

func _apply_gravity(delta):
	gravity = to_local(get_parent().get_position()).normalized() * 96
	normal = -to_local(get_parent().get_position()).normalized()
	velocity += gravity * delta

func _handle_movement():
	velocity += movDir* gravity.tangent().normalized() * movSpeed
	if movDir != 0:
		body.scale.x *= movDir

func _apply_movement():
	velocity = move_and_slide_with_snap(velocity, snapvect, normal, true)

