extends Building
class_name Tower

export var fireRate = 0.1

var _angleAtTimes = []


var _target = null
var _colliders = []
var _targetEndPos = null
var _currentlyFiring = false

func _ready():
	pass
	
func _on_asteroid_enter(collisionInfo):
	var newAsteroidEndPos = collisionInfo[3].get_position_at_time(collisionInfo[1])
	if _target == null and not _currentlyFiring:
		fire_coroutine()
	if _target == null or (
		position.distance_squared_to(newAsteroidEndPos) <
		position.distance_squared_to(_targetEndPos)):
		_target = collisionInfo[3]
		_targetEndPos

func _on_asteroid_exit(collisionInfo):
	if collisionInfo[3] == _target:
		_target = null
		var minDistance = float("inf")
		for collider in _colliders:
			var newDistance = position.distance_squared_to(collider[3].get_position_at_time(collider[1]))
			if minDistance > newDistance:
				minDistance = newDistance
				_target = collider[3]
	else:
		_colliders.erase(collisionInfo)
		
		
func fire_coroutine():
	while _target != null:
		fire()
		yield(get_tree().create_timer(fireRate), "timeout")
	
func fire():
	assert(1 == 0, "default behavior for tower fire not overriden!! WTF do I do?")
