extends RigidBody2D


const THROW_VELOCITY = 200

onready var timer = $Timer
onready var parent = get_parent()
onready var sprite = $Sprite

var is_grounded = false
var followCursor = false

#func _ready():
#	set_physics_process(false)


#func _physics_process(delta):
#	if followCursor :
#		sprite.rotation = (get_global_mouse_position()-get_global_position()).angle() - PI/2


func launch(velocity):
	set_mode(0)
	var temp = global_transform
	var scene = get_tree().current_scene
	get_parent().remove_child(self)
	scene.add_child(self)
	global_transform = temp
	apply_central_impulse(velocity)

func _on_Timer_timeout():
	queue_free()

func follow_cursor(following):
	followCursor = following

#damage player
#func _on_Hitarea_body_entered(body):
#	if body is Player:
#		if !is_grounded:
#			body.take_damage()
#			queue_free()
##			if body.immuneTimer.is_stopped():
##				#print("dab")
##				body.take_damage()
##				queue_free()
#		else:
#			pass
