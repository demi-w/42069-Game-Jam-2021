class_name Phantom extends RigidBody2D

const tower = preload("res://src/Tower/Tower.tscn")
const pathRes = preload("res://src/Predictor/Path.tscn")
export var planetPath : NodePath

onready var parent = get_parent()
onready var planet = get_parent().get_parent().get_parent()
onready var sprite = $Sprite
onready var planet_mask = $Planet_Mask

var last_path_pos = Vector2(0,0)
var is_grounded = false
var followCursor = false
var launched = false

func _physics_process(delta):
	if launched:
		global_rotation = linear_velocity.angle() + PI / 2
		if (get_position() - last_path_pos).length() > 60:
			spawn_path()
		


func launch(velocity):
	set_mode(0)
	var temp = global_transform
	var scene = parent
	parent.remove_child(self)
	scene.get_parent().add_child(self)
	global_transform = temp
	set_linear_velocity(velocity)
	launched = true
	parent = get_parent()
	last_path_pos = position


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


func set_from_planet(value):
	if value:
		set_collision_mask(0)
		planet_mask.connect("body_exited",self,"reset_collisions",[],CONNECT_ONESHOT)


func set_texture(texture):
	$Sprite.set_texture(texture)


func reset_collisions(body):
	set_collision_mask(18)


func set_collision(collision):
	$CollisionShape2D.set_shape(collision)


func _on_RigidBody2D_body_entered(body):
	queue_free()


func spawn_path():
	var newPath = pathRes.instance()
	newPath.set_visible(true)
	newPath.add_to_group("Paths")
	parent.add_child(newPath)
	newPath.set_position(position)
	newPath.set_rotation(rotation - PI / 2)
	last_path_pos = position


