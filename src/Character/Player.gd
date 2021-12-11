extends KinematicBody2D
class_name Player

var velocity = Vector2()
var gravity
var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _apply_gravity(delta):
	print(get_parent())
	gravity = -to_local(get_parent().get_position()).normalized() * 96
	print(gravity.length())
	velocity += gravity * delta
