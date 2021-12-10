extends RigidBody2D

const tower = preload("res://src/Tower/Tower.tscn")

const THROW_VELOCITY = 200

onready var parent = get_parent()
onready var sprite = $Sprite
onready var statemachine = $State_Machine

var is_grounded = false
var followCursor = false
var launched = false

#func _ready():
#	set_physics_process(false)


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
	statemachine.set_state(statemachine.states.Flying)

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
