extends RigidBody2D

const tower = preload("res://src/Tower/Tower.tscn")
const projectilePhantom = preload("res://src/Launcher/Projectile/ProjectilePhantom.tscn")

onready var parent = get_parent()
onready var sprite = $Sprite
onready var particles = $Particles

var is_grounded = false
var followCursor = false
var launched = false
#func _ready():
#	set_physics_process(false)

func _physics_process(delta):
	if launched:
		global_rotation = linear_velocity.angle() + PI / 2
		for particle in particles.get_children():
			particle.get_process_material().set_gravity(96 * Vector3((get_position().normalized()).x, -(get_position().normalized()).y, 0))
	else:
		rotation = (get_parent().launchDir.get_position() - get_position()).angle() + PI / 2

func launch(velocity):
	set_mode(0)
	var temp = global_transform
	var scene = parent
	parent.remove_child(self)
	scene.get_parent().add_child(self)
	global_transform = temp
#	apply_central_impulse(velocity)
	set_linear_velocity(velocity)
	parent = parent.get_parent()
	launched = true
	for particle in particles.get_children():
		particle.set_emitting(true)


func predict(direction):
	var phantom = projectilePhantom.instance()
	parent.add_child(phantom)
	phantom.add_to_group("Paths")
	phantom.set_position(get_position())
	phantom.launch(direction)

#	if currentTower == null:
#		currentTower = projectile.instance()
#		currentTower.get_node(@"Sprite").set_texture(load(towerList.get_tower(TowerType)))
#		add_child(currentTower)
#		currentTower.set_position(towerSpawn.get_position())

func _on_RigidBody2D_body_entered(body):
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
