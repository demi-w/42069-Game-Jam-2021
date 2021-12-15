extends Node2D

const projectilePhantom = preload("res://src/Predictor/ProjectilePhantom.tscn")

export var planetPath : NodePath

onready var _planet = get_parent().get_parent()

func _default_gravity_force():
	return 1

func _default_texture():
	return "res://src/Predictor/Defaults/DefaultPredict.png"

func _default_collision():
	return "res://src/Predictor/Defaults/DefaultPredict.tres"

func _default_sim_speed():
	return 1

var defaultPredictParameters = {
	"gravity_force" : funcref(self, "_default_gravity_force"),
	"texture" : funcref(self, "_default_texture"),
	"collision" : funcref(self, "_default_collision"),
	"sim_speed" : funcref(self, "_default_sim_speed"),
	"launch_position" : null,
	"velocity" : null
}


var _gravity_force = 1
var _texture = null
var _collision = null
var _sim_speed = 1
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
	phantom.set_gravity_scale(_gravity_force*_sim_speed*_sim_speed)
	phantom.set_texture(_texture)
	phantom.set_collision(_collision)
	phantom.add_to_group("Paths")
	phantom.set_position(_launch_position)
	phantom.launch(_velocity*_sim_speed)
