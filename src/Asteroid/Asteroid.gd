extends RigidBody2D
class_name Asteroid

export (float) var max_health = 15.0
export (float) var damage = 50


var health

#Forgot I was defying naming convention, fix this if u wanna but i cannot b fuked to
func _defaultInitDist(configInfo : Dictionary):
	return (400+configInfo["rng"].randf_range(-15,15))/_worldScale

func _defaultLinearFall(configInfo : Dictionary):
	#return 500
	return (8+configInfo["rng"].randf_range(0,12))

func _defaultGiveUpDist(configInfo : Dictionary):
	return 1
	#return (1.4-(configInfo["rng"].randf_range(0,0.15)/_worldScale)/2)

func _defaultPeriod(configInfo : Dictionary):
	return 1/((.15+configInfo["rng"].randf_range(0,.3))*_worldScale)
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

func _init().():
	health = max_health

func setupParameters(params : Dictionary, configInfo : Dictionary):
	for param in defaultParamFuncs.keys():
		if params.has(param):
			self.set("_" + param,params[param])
		else:
			assert(defaultParamFuncs[param] != null, "Mandatory parameter " + param + " not provided.")
			self.set("_" + param,defaultParamFuncs[param].call_func(configInfo))
		
# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_node("Tween")
	tween.interpolate_property(self, "scale",
		Vector2(0, 0), Vector2(1, 1), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	var initForce = Vector2.DOWN*_linearFall/10 + Vector2.RIGHT/_period
	initForce = initForce.rotated(_posRotation)
	add_central_force(initForce*1.1)
	position = Vector2.UP.rotated(_posRotation)*_initDist*_worldScale
	#_initDist += _linearFall
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#pass
	var distFromCenter = position.distance_to(Vector2.ZERO)
	linear_damp = clamp(1024-distFromCenter,0,200)/1024 + 0.3
	add_central_force(position.direction_to(Vector2.ZERO)*delta/distFromCenter*14240)
	if distFromCenter > 4096:
		var curAngle = position.angle()
		linear_velocity = Vector2.ZERO
		position = Vector2.UP.rotated(curAngle)*4000
		add_central_force(position.direction_to(Vector2.ZERO)*124*delta)
	


func _on_Asteroid_body_entered(body):
	if body is Planet: #if it's a planet! gotta love gdscript
		GameData.planet_health -= 1
		die()
	
func die():
	var new_explosion = GameData.asteroid_spawner.asteroidBoom.instance()
	var new_scrap = GameData.asteroid_spawner.scrapPrefab.instance()
	get_parent().call_deferred("add_child",new_scrap)
	get_parent().call_deferred("add_child", new_explosion)
	new_scrap.global_transform = global_transform
	new_explosion.global_transform = global_transform
	queue_free()


func take_damage(_damage = 1):
	_set_health(health - _damage)


func _set_health(value):
	var prev_health = health
	health = clamp(value,0,max_health)
	if health != prev_health:
#		emit_signal("health_updated", health)
		if health == 0:
			die()
