extends Building
class_name Tower

export var fireRate = 0.1
export var percentOfCircleVisible = 0.5
onready var triggerdome = get_node("Area2D")

var _currentlyFiring = false
var _lookAngle = null

func _ready():
	_lookAngle = Vector2.RIGHT.rotated(position.angle())
	triggerdome.connect("body_entered", self, "_on_Area2D_body_entered")
	
#func _on_asteroid_enter(collisionInfo):
#	var newAsteroidEndPos = collisionInfo[3].get_position_at_time(collisionInfo[1])
#	if _target == null and not _currentlyFiring:
#		fire_coroutine()
#	if _target == null or (
#		position.distance_squared_to(newAsteroidEndPos) <
#		position.distance_squared_to(_targetEndPos)):
#		_target = collisionInfo[3]
#		_targetEndPos

#func _on_asteroid_exit(collisionInfo):
#	if collisionInfo[3] == _target:
#		_target = null
#		var minDistance = float("inf")
#		for collider in _colliders:
#			var newDistance = position.distance_squared_to(collider[3].get_position_at_time(collider[1]))
#			if minDistance > newDistance:
#				minDistance = newDistance
#				_target = collider[3]
#	else:
#		_colliders.erase(collisionInfo)
		
func can_fire_at(body):
	var AP = (position - body.position).normalized()
	return AP.dot(_lookAngle) > percentOfCircleVisible*-2 + 1

func fire_coroutine():
	_currentlyFiring = true
	while true:
		var target = select_target()
		if target == null:
			break
		fire(target)
		yield(get_tree().create_timer(fireRate), "timeout")
	_currentlyFiring = false

func select_target():
	var target = null
	var minDistance = 9999999999999999999.0
	for asteroid in triggerdome.get_overlapping_bodies():
		if (can_fire_at(asteroid) &&
				Vector2.ZERO.distance_squared_to(asteroid.position) < minDistance):
			minDistance = Vector2.ZERO.distance_squared_to(asteroid.position)
			target = asteroid
	return target

func fire(target):
	assert(1 == 0, "default behavior for tower fire not overriden!! WTF do I do?")


func _on_Area2D_body_entered(body):
	if _currentlyFiring == false:
		fire_coroutine()
