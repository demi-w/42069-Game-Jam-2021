extends RigidBody2D
class_name Projectile

onready var sprite = $Sprite
onready var particles = $Particles

var building = null setget set_stored
var followCursor = false
var launched = false
var armed = false
var lastPosition


func _physics_process(_delta):
	if launched:
		global_rotation = linear_velocity.angle() + PI / 2
		for particle in particles.get_children():
			particle.get_process_material().set_gravity(-96 * Vector3((get_position().normalized()).x, 
																	(get_position().normalized()).y, 
																	0))
		if get_vertical_direction() >= 0:
			for particle in particles.get_children():
				particle.set_emitting(false)


func _process(_delta):
	lastPosition = get_position()


func launch(velocity):
	set_mode(0)
	var temp = global_transform
	var parent = get_parent()
	parent.remove_child(self)
	parent.get_parent().add_child(self)
	global_transform = temp
#	apply_central_impulse(velocity)
	set_linear_velocity(velocity)
	set_collision_layer(8)
	launched = true
	for particle in particles.get_children():
		particle.set_emitting(true)
	connect("body_entered",self,"_on_landed") #connect when the code is figured out, right now this is more fun to watch


func _on_landed(body):
	if building != null:
		if body is Planet:
			spawn_building(body)
			queue_free()


func arm():
	set_collision_layer(0)
	set_mode(1)
	armed = true


func get_vertical_direction():
	return lastPosition.length() - get_position().length()


func set_stored(building_reference):
	building = building_reference


func spawn_building(planet):
	var new_building = building.instance()
	new_building.global_position = global_position
	new_building.set_position((new_building.position / new_building.position.length() * planet.planetRadius))
	planet.call_deferred("add_child", new_building)
