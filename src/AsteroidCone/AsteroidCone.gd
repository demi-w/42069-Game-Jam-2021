extends Node2D

signal enter(collisionInfo)
signal exit(collisionInfo)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var arcLength = PI/6
export var coneRange = 0.8

var _startRads = null
var _endRads = null
var _asteroidTimes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	GameData.asteroid_spawner.connect("new",self,"_new_asteroid")
	var baseRads = position.angle() + PI / 2
	_startRads = fmod(baseRads-arcLength,TAU)
	_endRads = fmod(baseRads-arcLength,TAU)
	_asteroidTimes = GameData.asteroid_spawner.asteroids_intersect_cone(_startRads,_endRads,coneRange)

func enter_coroutine():
	while _asteroidTimes.length() > 0:
		var collisionInfo = _asteroidTimes.pop_front()
		yield(get_tree().create_timer(collisionInfo[0]-OS.get_ticks_msec()/1000), "timeout")
		emit_signal("enter",collisionInfo)
		exit_coroutine(collisionInfo)

func exit_coroutine(collisionInfo):
	yield(get_tree().create_timer(collisionInfo[1]-OS.get_ticks_msec()/1000), "timeout")
	emit_signal("exit",collisionInfo)
	
func _new_asteroid(asteroid):
	GameData.asteroid_spawner.merge_sorted_collisionInfo_lists(_asteroidTimes,asteroid.times_intersect_cone(_startRads,_endRads,coneRange))
#Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
