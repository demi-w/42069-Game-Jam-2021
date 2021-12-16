extends RigidBody2D

const tower = preload("res://src/Tower/Tower.tscn")

onready var sprite = $Sprite
onready var particles = $Particles

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
	launched = true
	for particle in particles.get_children():
		particle.set_emitting(true)
#	connect("body_entered",self,"_on_landed") #connect when the code is figured out, right now this is more fun to watch


func _on_landed(body):
	if body is Planet:
		var newTower = tower.instance()
		var texture = get_node(@"Sprite").get_texture()
		body.add_child(newTower)
		newTower.global_position = global_position
		newTower.set_rotation(newTower.get_position().angle() + PI / 2)
		newTower.set_position((newTower.position / newTower.position.length()) * 520) #Sets vector length to 520pixels
		newTower.get_node(@"Sprite").set_texture(texture)
		queue_free()
	elif body is Tower:
		var newTower = tower.instance()
		var texture = get_node(@"Sprite").get_texture()
		body.add_child(newTower)
		newTower.set_rotation(body.get_node(@"Sprite").get_rotation())
		newTower.set_position(Vector2(0,-16))
		newTower.get_node(@"Sprite").set_texture(texture)
		queue_free()


func arm():
	set_mode(1)
	armed = true


func get_vertical_direction():
	return lastPosition.length() - get_position().length()

