extends RigidBody2D

func _defaultInitDist(configInfo : Dictionary):
	return (150+configInfo["rng"].randf_range(-15,15))/_worldScale

func _defaultLinearFall(configInfo : Dictionary):
	return (0.5+configInfo["rng"].randf_range(0,4))

func _defaultGiveUpDist(configInfo : Dictionary):
	return (1.4-(configInfo["rng"].randf_range(0,0.15)/_worldScale)/2)

func _defaultPeriod(configInfo : Dictionary):
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

var timeAlive = 0
var dead = false
var rng : RandomNumberGenerator

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func setupParameters(params : Dictionary, configInfo : Dictionary):
	for param in defaultParamFuncs.keys():
		if params.has(param):
			self.set("_" + param,params[param])
		else:
			assert(defaultParamFuncs[param] != null, "Mandatory parameter " + param + " not provided.")
			self.set("_" + param,defaultParamFuncs[param].call_func(configInfo))

func _input(event):
	if Input.is_action_pressed("ui_accept"):
		dead = true
		start_fall()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	setupParameters(
		{"worldScale" : parent.planetRadius},
		{"rng": rng}
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeAlive += delta
	if not dead:
		position = get_position_at_time(timeAlive)*_worldScale
		global_rotation = get_position().angle() + PI / 2
	else:
		global_rotation = get_linear_velocity().angle() + PI / 2 

func get_position_at_time(time):
	var periodTime = time*_period #Default period takes 1 second
	return Vector2(_initDist*cos(2*PI*periodTime)-_linearFall*periodTime*cos(2*PI*periodTime),
					_initDist*sin(2*PI*periodTime)-_linearFall*periodTime*sin(2*PI*periodTime)).rotated(_posRotation)

func start_fall():
	set_mode(0)
	set_linear_velocity(get_position().tangent().normalized() * 500)
