extends Building

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
var _time_to_boom: float = 5

onready var particles = $Particles
onready var parent = get_parent()
onready var right_door = $Right_Door
onready var left_door = $Left_Door
onready var base = $Base

var landed = false
var timeAlive = 0
var falling = false
var rng : RandomNumberGenerator
var predict_thing = null
var start_posRotation = null
var scrap_force = Vector2(40,0)
var scrap_force_offset = Vector2(0,10)


func setupParameters(params : Dictionary, configInfo : Dictionary):
	for param in defaultParamFuncs.keys():
		if params.has(param):
			self.set("_" + param,params[param])
		else:
			assert(defaultParamFuncs[param] != null, "Mandatory parameter " + param + " not provided.")
			self.set("_" + param,defaultParamFuncs[param].call_func(configInfo))


#func _input(event):
#	if Input.is_action_pressed("ui_accept") && not falling:
#		start_fall()


func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	setupParameters(
		{"worldScale" : get_parent().get_radius(),
		"posRotation" : PI,
		"initDist" : (1.5*parent.get_radius()) / parent.get_radius(),
		"period" : 1.0/30.0},
		{"rng": rng}
	)
	pass


func _process(delta):
#	timeAlive += delta
	if not falling:
#		position = get_position_at_time(timeAlive)*_worldScale
#		global_rotation = get_position().angle() + PI
		pass
		position = get_position_at_time(0)*_worldScale
	else:
		timeAlive += delta
#		global_rotation = get_linear_velocity().angle() - PI / 2
		position = get_position_at_time(timeAlive)*_worldScale
		global_rotation = get_position().angle() + PI
		for particle in particles.get_children():
			particle.get_process_material().set_gravity(-96 * Vector3((get_position().normalized()).x, 
																	(get_position().normalized()).y, 
																	0))


func get_position_at_time(time):
	var periodTime = time*_period #Default period takes 1 second
	return Vector2(_initDist*cos(2*PI*periodTime),
					_initDist*sin(2*PI*periodTime)).rotated(_posRotation)





#func get_fall_at_time(time):
#	var periodTime = time*_period
#	return Vector2(2*_initDist*cos((PI * periodTime))-_initDist*cos(2*PI*periodTime),
#					2*_initDist*sin((PI * periodTime))-_initDist*sin(2*PI*periodTime)).rotated(_posRotation) 



func start_fall():
	predict_thing = GameData.prediction_flag.instance()
	start_posRotation = get_position().angle()
	falling = true
	predict_thing.set_position(get_position_at_time(timeAlive*(_period)+5)*_worldScale)
	predict_thing.time_base = abs(timeAlive*(_period)+5 - timeAlive)
	print(timeAlive)
	GameData.current_level.get_node("Planet").add_child(predict_thing)
	for particle in particles.get_children():
		particle.set_emitting(true)
	explode_coroutine()


func explode_coroutine():
	yield(get_tree().create_timer(_time_to_boom),"timeout")
	boom()


func boom():
	predict_thing.queue_free()
	var vel = ((_initDist * _worldScale) * (get_position().angle()-start_posRotation)) / _time_to_boom
	disconnect_bodies((get_position().normalized().rotated(PI/2)*vel))
	randomize_scrap((get_position().normalized().rotated(PI/2)*vel))
	for particle in particles.get_children():
		particle.set_emitting(false)
	despawn_all()


func disconnect_bodies(vel):
	change_parent(right_door,get_parent())
	change_parent(left_door,get_parent())
	change_parent(base, get_parent())
	right_door.set_mode(0)
	left_door.set_mode(0)
	base.set_mode(0)
	left_door.set_linear_velocity(vel)
	left_door.set_angular_velocity(-1)
	right_door.set_linear_velocity(vel)
	right_door.set_angular_velocity(1)
	base.set_linear_velocity(vel)
	base.set_angular_velocity(_period/2)
	left_door.apply_impulse(scrap_force_offset.rotated(_posRotation + get_rotation()),scrap_force.rotated(_posRotation + get_rotation()))
	right_door.apply_impulse(scrap_force_offset.rotated(_posRotation + get_rotation()),Vector2(-scrap_force.x,scrap_force.y).rotated(_posRotation + get_rotation()))


func randomize_scrap(vel):
	randomize()
	for scrap in $Scrap_Cluster.get_children():
		change_parent(scrap, get_parent())
		scrap.add_collision_exception_with(right_door)
		scrap.add_collision_exception_with(left_door)
		scrap.add_collision_exception_with(base)
		scrap.set_mode(0)
		scrap.set_linear_velocity(vel+Vector2(ceil(rand_range(10,40)),ceil(rand_range(10,40))).rotated(_posRotation + get_rotation()))



func despawn_all():
	yield(get_tree().create_timer(20), "timeout")
	right_door.queue_free()
	left_door.queue_free()
	base.queue_free()
	queue_free()


#func throw_scrap():
#	var left_door = $Left_Door
#	var right_door = $Right_Door
#	var rotPosition = get_position().angle()+PI/2
#	change_parent(left_door, get_parent())
#	change_parent(right_door, get_parent())
#	if left_door != null:
#		left_door.apply_impulse(scrap_force_offset.rotated(rotPosition),scrap_force.rotated(rotPosition))
#	if right_door != null:
#		right_door.apply_impulse(scrap_force_offset.rotated(rotPosition),Vector2(-scrap_force.x,scrap_force.y).rotated(rotPosition))
#	ready = true


func _on_landed(body):
	var staticPod = StaticPod.instance()
	parent.call_deferred("add_child",staticPod)
	staticPod.set_position(get_position().normalized()*520)
	staticPod.set_rotation(get_position().angle() + PI/2)
	predict_thing.queue_free()
	queue_free()
