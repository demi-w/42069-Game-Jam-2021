extends Node

const asteroidPrefab = preload("res://src/Asteroid/Asteroid.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"



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
	queueAsteroids(50000)
	spawner_coroutine()
	spawner_coroutine()
	spawner_coroutine()
	spawner_coroutine()
	spawner_coroutine()

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
			{"worldScale":_planet.planetRadius},
			{
			"rng":_rng
			})
		add_child(newAsteroid)
		#print("Added asteroid")
		_queuedAsteroids -= 1
		yield(get_tree().create_timer(spawnInterval), "timeout")
	_spawnerRunning = false
