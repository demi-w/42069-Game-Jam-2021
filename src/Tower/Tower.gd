extends Building
class_name Tower

export var arcRadius = PI/6
export var towerRange = 50

var _angleAtTimes = []

var _asteroidSpawner = null
var _planet = null
var _startRadians = null
var _endRadians = null

func _ready():
	var baseRads = atan2(position.y - _planet.y, position.x - _planet.x)
	print(baseRads)
	_asteroidSpawner.asteroids_intersect_cone()
	
