extends Node

const asteroidPrefab = preload("res://src/Asteroid/Asteroid.tscn")

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

func queueAsteroids(newAsteroids:int):
	_queuedAsteroids += newAsteroids
	if _queuedAsteroids > 0 and not _spawnerRunning:
		spawner_coroutine()

func remove_asteroid(asteroid : Node2D):
	_asteroids.erase(asteroid)

func spawner_coroutine():
	_spawnerRunning = true
	while _queuedAsteroids > 0:
		var newAsteroid := asteroidPrefab.instance()
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
		#print("Added asteroid")
		_queuedAsteroids -= 1
		yield(get_tree().create_timer(spawnInterval), "timeout")
	_spawnerRunning = false

func asteroids_intersect_cone(startRads,endRads,coneRange):
	var sortedByTime = []
	for asteroid in _asteroids:
		var unsortedAdditions = asteroid.times_intersect_cone(startRads,endRads,coneRange)
		var unsortedIndex = 0
		var sortedIndex = 0
		while sortedIndex < sortedByTime.length() and unsortedIndex < unsortedAdditions.length():
			if sortedByTime[sortedIndex][0] > unsortedAdditions[unsortedIndex][0]: 
				unsortedAdditions[unsortedIndex].push(asteroid)
				unsortedAdditions[unsortedIndex][0]
				sortedByTime.insert(sortedIndex,unsortedAdditions[unsortedIndex])
				unsortedIndex += 1
			sortedIndex += 1
		while unsortedIndex < unsortedAdditions.length():
			unsortedAdditions[unsortedIndex].push(asteroid)
			sortedByTime.append(unsortedAdditions[unsortedIndex])
			unsortedIndex += 1
	return sortedByTime
