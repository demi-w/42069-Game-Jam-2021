extends Node2D

const asteroidPhysics = preload("res://src/Asteroid/AsteroidPhysics.tscn")

#Forgot I was defying naming convention, fix this if u wanna but i cannot b fuked to
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


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var spawnTime = 0
var simRadius = 5
var timeAlive = 0
var deathTime
var _asteroidHash
var dead := false

#THESE SHOULD BE CONSTANT PER ASTEROID (teehee they are now hidden)
var _worldScale = 80
var _initDist : float = 2
var _linearFall : float = 0.2
var _giveUpDist : float = 1.2
var _period : float = 1.0/30.0
var _posRotation: float = 0 # >= 0 && < 2*PI, determines offset for start above planet

func setupParameters(params : Dictionary, configInfo : Dictionary):
	for param in defaultParamFuncs.keys():
		if params.has(param):
			self.set("_" + param,params[param])
		else:
			assert(defaultParamFuncs[param] != null, "Mandatory parameter " + param + " not provided.")
			self.set("_" + param,defaultParamFuncs[param].call_func(configInfo))
		
# Called when the node enters the scene tree for the first time.
func _ready():
	deathTime = calc_death_time()
	give_up_coroutine()
	var rotationAsPercent = _posRotation / PI / 2.0
	timeAlive = rotationAsPercent / _period
	spawnTime = OS.get_ticks_msec()/1000 - timeAlive
	_initDist += rotationAsPercent * _linearFall
	position = get_position_at_time(timeAlive)*_worldScale

func _process(delta):
	timeAlive += delta
	if not dead:
		position = get_position_at_time(timeAlive)*_worldScale
	
func get_position_at_time(time):
	var periodTime = time*_period #Default period takes 1 second
	return Vector2(_initDist*cos(TAU*periodTime)-_linearFall*periodTime*cos(TAU	*periodTime),
					_initDist*sin(TAU*periodTime)-_linearFall*periodTime*sin(TAU*periodTime))
	
func calc_death_time():
	if(_initDist-_giveUpDist == 0):
		return 0
	elif _linearFall == 0:
		return float("inf")
	else:
		return (_initDist-_giveUpDist)/_linearFall/_period

func give_up_coroutine():
	yield(get_tree().create_timer(deathTime), "timeout")
	#print("AHH SHOULD GIVE UP NOW")
	die()
	

func die():
	get_parent().remove_asteroid(self)
	dead = true
	add_child(asteroidPhysics.instance())
	#get_parent().remove_child(self)

func times_intersect_ray(rads,rayRange, useSimTime=false):
	var addSpawnTime = 0 if useSimTime else spawnTime
	var timeToGetToRads = rads/(TAU*_period)
	var timeToGetToRangeRot = ceil((1-rayRange-rads*_linearFall/TAU)/_linearFall)/_period
	var timeAtIntersect = timeToGetToRads + timeToGetToRangeRot + addSpawnTime
	var times = []
	while timeAtIntersect < deathTime:
		times.append(timeAtIntersect + addSpawnTime)
		timeAtIntersect += 1/_period
	return times

func times_intersect_cone(startRads,endRads,coneRange, useSimTime=false):
	var addSpawnTime = 0 if useSimTime else spawnTime
	var endInTOfStart = fmod(endRads-startRads,TAU)
	var collisionInTOfStart = fmod((1-coneRange)/_linearFall,1)*TAU
	var collisionAngle = fmod(clamp(collisionInTOfStart,0,endInTOfStart) + startRads,TAU)
	var bonks = times_intersect_ray(collisionAngle,coneRange)
	if bonks == []:
		return bonks
	else:
		var timeAndAngles = [bonks[0]+addSpawnTime,abs(endRads-collisionAngle)/TAU/_period+addSpawnTime,collisionAngle]
		var rayTimes = times_intersect_ray(startRads,coneRange,useSimTime)
		rayTimes.pop_front()
		var timeToPassCone = abs(endRads-startRads)/TAU/_period
		for i in rayTimes:
			timeAndAngles.append([i,i+timeToPassCone,startRads])
		return timeAndAngles

func time_intersect_asteroid(other,useSimTime=false):
	var a = ((simRadius+other.simRadius-_initDist+other._initDist) / 
		(other._linearFall*other._initDist - _linearFall*_initDist))
	
	a = a if a > 0 else float("inf")
	
	var b = ((-simRadius-other.simRadius-_initDist+other._initDist) / 
		(other._linearFall*other._initDist - _linearFall*_initDist))
	
	b = b if b > 0 else float("inf")
	
	return min(a,b) + 0 if useSimTime else spawnTime


#Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
