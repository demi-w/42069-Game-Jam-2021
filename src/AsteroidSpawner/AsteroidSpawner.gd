extends Node

const asteroidPrefabs = [
preload("res://src/Asteroid/DifferentAsteroids/LargeAsteroid.tscn"),
preload("res://src/Asteroid/DifferentAsteroids/MediumAsteroid.tscn"),
preload("res://src/Asteroid/DifferentAsteroids/SmallAsteroid.tscn")]
signal new(asteroid)

export var difficulty : float = 3
export var difficulty_end : float = 6
export var spawning_period : float = 12
export var expected_level_time : float = 60

export var spawnInterval : float = 3
export var asteroidsOnStart : float = 0
export var planetPath : NodePath

onready var _planet = get_node(planetPath)
var _spawnerRunning := false
var _asteroids := []
var _queuedAsteroids := 0
var _rng : RandomNumberGenerator

func _ready():
	_rng = RandomNumberGenerator.new()
	_rng.randomize()
	queueAsteroids(asteroidsOnStart)
	level_coroutine(difficulty,difficulty_end,spawning_period,expected_level_time)

func queueAsteroids(newAsteroids:int):
	_queuedAsteroids += newAsteroids
	if _queuedAsteroids > 0 and not _spawnerRunning:
		spawner_coroutine()

func remove_asteroid(asteroid : Node2D):
	_asteroids.erase(asteroid)
	
func level_coroutine(difficulty,difficulty_end,spawning_period,expected_level_time,grace_period = 0):
	yield(get_tree().create_timer(grace_period), "timeout")
	var startTime = 0
	var rng = RandomNumberGenerator.new()
	while true:
		var asteroidsToSpawn = round(difficulty + rng.randf_range(-0.5,0.5))
		var spawnDelays = []
		var delaySum = 0
		for i in range(asteroidsToSpawn+1):
			spawnDelays.append(rng.randf_range(1,100))
			delaySum += spawnDelays[i]
		#after creating a bunch of random values, create a multiplier such that sum(delays) = spawning_period (with some rng thrown in for spice)
		var funkyPeriod = spawning_period*rng.randf_range(0.8,1)
		var spawnDelayMult = funkyPeriod/delaySum
		#print("delay times:",spawnDelays)
		#print("spawning period:",spawning_period)
		#print("spawn delay multiplier:",spawnDelayMult)
		yield(get_tree().create_timer(spawnDelays[0]*spawnDelayMult), "timeout")
		for delayTime in spawnDelays.slice(1,asteroidsToSpawn+1):
			new_asteroid()
			#print("waiting ",delayTime*spawnDelayMult,"seconds")
			yield(get_tree().create_timer(delayTime*spawnDelayMult), "timeout")
		startTime += funkyPeriod
		var percentProgression = startTime/expected_level_time
		difficulty = difficulty*(1-percentProgression) + difficulty_end*percentProgression
func spawner_coroutine():
	_spawnerRunning = true
	while _queuedAsteroids > 0:
		#print("Added asteroid")
		new_asteroid()
		_queuedAsteroids -= 1
		yield(get_tree().create_timer(spawnInterval), "timeout")
	_spawnerRunning = false

func new_asteroid():
	var newAsteroid = asteroidPrefabs[_rng.randi_range(0,2)].instance()
	_asteroids.append(newAsteroid)
	newAsteroid.setupParameters(
						#{"period":1/(76+_rng.randf_range(0,4)),
		#"initDist":1.4+_rng.randf_range(-0.01,0.01),
		#"giveUpDist":1.1,
		{
			"worldScale":_planet.planetRadius
#				"linearFall":_rng.randf_range(0,0.2),
#				"linearFall":0,
#				"initDist":1,
#				"giveUpDist":0.8,
#				"initDist": 1.1 + _rng.randf_range(-0.2,0.2)
		},
		{
			"rng":_rng
		})
	add_child(newAsteroid)
	emit_signal("new",newAsteroid)

func asteroids_intersect_cone(startRads,endRads,coneRange):
	var sortedByTime = []
	for asteroid in _asteroids:
		var unsortedAdditions = asteroid.times_intersect_cone(startRads,endRads,coneRange)
		for additionIndex in range(unsortedAdditions.length()):
			unsortedAdditions[additionIndex].push(asteroid)
		merge_sorted_collisionInfo_lists(sortedByTime,unsortedAdditions)
	return sortedByTime

static func merge_sorted_collisionInfo_lists(mergeInto,list2):
	var firstIndex = 0
	var secondIndex = 0
	while firstIndex < mergeInto.length() and secondIndex < list2.length():
		if mergeInto[firstIndex][0] > list2[secondIndex][0]: 
			mergeInto.insert(firstIndex,list2[secondIndex])
			secondIndex += 1
		firstIndex += 1
	while secondIndex < list2.length():
		mergeInto.append(list2[secondIndex])
		secondIndex += 1
	return mergeInto
