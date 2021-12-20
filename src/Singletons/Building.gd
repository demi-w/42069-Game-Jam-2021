extends Node2D
class_name Building

var land_sound = preload("res://assets/Audio/Building General/buildingLanding.wav")

var can_zoom  = false
var camera_pos = Vector2(0,0)
var player = null
var max_health
var health


func _init(_health = 10).():
	max_health = _health
	health = max_health


#When using the enter/exit building functions you MUST
#change the parent if you intend it to be enterable
func enter_building(_entering):
	return false


func exit_building():
	pass


func store_item(_item):
	return false


func change_parent(changed = null, new_owner = null):
	if changed != null:
		var old_owner = changed.get_parent()
		if new_owner != old_owner:
			var temp = changed.global_transform
			old_owner.remove_child(changed)
			new_owner.add_child(changed)
			changed.global_transform = temp


func spawn():
	pass


func despawn():
	queue_free()


func take_damage(damage = 1):
	_set_health(health - damage)


func _set_health(value):
	var prev_health = health
	health = clamp(value,0,max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			despawn()
