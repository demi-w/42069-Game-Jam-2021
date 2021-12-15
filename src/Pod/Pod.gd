extends RigidBody2D

const StaticPod = preload("res://src/Pod/StaticPod.tscn")

func _defaultInitDist(configInfo : Dictionary):
	return (150+configInfo["rng"].randf_range(-15,15))/_worldScale

func _defaultLinearFall(configInfo : Dictionary):
	return (0.5+configInfo["rng"].randf_range(0,4))

func _defaultGiveUpDist(configInfo : Dictionary):
	return (1.4-(configInfo["rng"].randf_range(0,0.15)/_worldScale)/2)

func _defaultPeriod(configInfo : Dictionary):
	#print((1.5+configInfo["rng"].randf_range(0,3))*_worldScale)
	return 1/((1.5+configInfo["rng"].randf_range(0,3))*_worldScale)
	#return 1/(15+rng.randf_range(0,5)*rng.randf_range(0,6))

func _defaultPosRotation(configInfo : Dictionary):
	return configInfo["rng"].randf_range(0,2*PI)

func _defaultAsteroidHash(configInfo : Dictionary):
	return configInfo["rng"].randi()

var defaultParamFuncs = {
	"initDist" : funcref(self,"_defaultInitDist"),
	"linearFall" : funcref(self,"_defaultLinearFall"),
	"giveUpDist" : funcref(self,"_defaultGiveUpDist"),
	"period" : funcref(self,"_defaultPeriod"),
	"posRotation" : funcref(self,"_defaultPosRotation"),
	"asteroidHash" : funcref(self,"_defaultAsteroidHash"),
	"worldScale" : null
}

#THESE SHOULD BE CONSTANT PER ASTEROID (teehee they are now hidden)
var _worldScale = 80
var _initDist : float = 2
var _linearFall : float = 0.2
var _giveUpDist : float = 1.2
var _period : float = 1.0/30.0
var _posRotation: float = 0 # >= 0 && < 2*PI, determines offset for start above planet

onready var parent = get_parent()

var landed = false
var timeAlive = 0
var falling = false
var rng : RandomNumberGenerator


func setupParameters(params : Dictionary, configInfo : Dictionary):
	for param in defaultParamFuncs.keys():
		if params.has(param):
			self.set("_" + param,params[param])
		else:
			assert(defaultParamFuncs[param] != null, "Mandatory parameter " + param + " not provided.")
			self.set("_" + param,defaultParamFuncs[param].call_func(configInfo))

func _input(event):
	if Input.is_action_pressed("ui_accept"):
		start_fall()


func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	setupParameters(
		{"worldScale" : parent.get_radius(),
		"posRotation" : -PI/2,
		"initDist" : (parent.get_radius() + 150) / parent.get_radius()},
		{"rng": rng}
	)
	pass


func _process(delta):
	timeAlive += delta
	if not falling:
		position = get_position_at_time(timeAlive)*_worldScale
		global_rotation = get_position().angle()
	else:
#		print(get_linear_velocity().project(get_linear_velocity().tangent()).length())
		global_rotation = get_linear_velocity().angle() - PI / 2


func get_position_at_time(time):
	var periodTime = time*_period #Default period takes 1 second
	return Vector2(_initDist*cos(2*PI*periodTime),
					_initDist*sin(2*PI*periodTime)).rotated(_posRotation)

#Possible fall equation
#will have to set time to 0 and change _posRotation
#	var periodTime = time*_period
#	return Vector2(2*_initDist*sin((2 * PI * periodTime)/ 2)-_initDist*sin(t),
#					2*_initDist*cos((2 * PI * periodTime)/ 2)-_initDist*cos(t)).rotated(_posRotation) 

func start_fall():
	set_mode(0)
	falling = true
	set_linear_velocity(-get_position().tangent().normalized())


#This was developed back when I was young and dreamy and wanted to use 
#	only one scene for the pod but god said no
#func switch_to_planet():
#	set_linear_velocity(Vector2(0,0))
#	set_angular_velocity(0)
#	set_mode(MODE_STATIC)
#	set_collision_layer(16)
#	set_collision_mask(0)
#	set_rotation(get_position().angle() + PI / 2)
#	set_position(get_position().normalized() * 520)
#	print(get_collision_mask_bit(0))



func _on_landed(body):
	var staticPod = StaticPod.instance()
	parent.call_deferred("add_child",staticPod)
	staticPod.set_position(get_position().normalized()*520)
	staticPod.set_rotation(get_position().angle() + PI/2)
	queue_free()
