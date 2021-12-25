extends Node2D
class_name Building

export (float) var max_health = 10.0

onready var sound = get_node("Sounds/Landing_Sound")
onready var tween = get_node("Tween")

var land_sound = preload("res://assets/Audio/Building General/buildingLanding.wav")

var can_zoom  = false
var camera_pos = Vector2(0,0)
var player = null
var health


func _init().():
	health = max_health


func _ready():
	rotation = get_position().angle()+PI/2
	position = get_position().normalized()*512


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


func spawn():
	if !sound.is_playing():
		sound.stream = land_sound
		sound.play()
	start_build()


func start_build():
	tween.interpolate_property(self,"position", 
				get_position() + Vector2(0,24).rotated(get_position().angle() + PI/2), get_position(),4)
	tween.interpolate_property(self,"modulate:a",
				0, 1, 4)
	tween.connect("tween_completed", self, "start")
	tween.start()
