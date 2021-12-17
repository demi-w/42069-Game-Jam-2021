extends Node2D

const projectilePhantom = preload("res://src/Predictor/ProjectilePhantom.tscn")

export var planetPath : NodePath

onready var phantom_base = $Phantom
onready var _planet = get_parent().get_parent()

func _default_gravity_force():
	return 1

func _default_texture():
	return phantom_base.get_node("Sprite").get_texture()

func _default_texture_region():
	return Rect2(Vector2(0,0),_texture.get_size())
#	return phantom_base.get_node("Sprite").get_region_rect()

func _default_texture_scale():
	return phantom_base.get_node("Sprite").get_scale()

func _default_collision():
	return phantom_base.shape_owner_get_owner(phantom_base.get_shape_owners()[0]).get_shape()

func _default_sim_speed():
	return 1

func _default_from_planet():
	return false

var defaultPredictParameters = {
	"gravity_force" : funcref(self, "_default_gravity_force"),
	"texture" : funcref(self, "_default_texture"),
	"texture_region" : funcref(self, "_default_texture_region"),
	"texture_scale" : funcref(self, "_default_texture_scale"),
	"collision" : funcref(self, "_default_collision"),
	"sim_speed" : funcref(self, "_default_sim_speed"),
	"from_planet" : funcref(self, "_default_from_planet"),
	"launch_position" : null,
	"velocity" : null
}


var _gravity_force = 1
var _texture = null
var _texture_region = Rect2(Vector2(0,0),Vector2(16,32))
var _texture_scale = Vector2(1,1)
var _collision = null
var _sim_speed = 1
var _from_planet = false
var _velocity = Vector2(0,0)
var _launch_position = Vector2(0,0)


func predict(params : Dictionary):
	for param in defaultPredictParameters.keys():
		if params.has(param):
			self.set("_" + param,params[param])
		else:
			assert(defaultPredictParameters[param] != null, "Mandatory parameter " + param + " not provided.")
			self.set("_" + param, defaultPredictParameters[param].call_func())
	launch()


func end_predict():
	get_tree().call_group("Paths", "queue_free")


func launch():
	var phantom = projectilePhantom.instance()
	add_child(phantom)
	set_things(phantom)
	phantom.launch(_velocity*_sim_speed)


func set_things(phantom):
	phantom.set_gravity_scale(_gravity_force*_sim_speed*_sim_speed)
	phantom.set_from_planet(_from_planet)
	if _texture.get_path() != _default_texture().get_path():
		phantom.set_texture(_texture)
		phantom.set_region_rect(_texture_region)
		phantom.set_scale(_texture_scale)
	phantom.set_collision(_collision)
	phantom.add_to_group("Paths")
	phantom.set_position(_launch_position)
