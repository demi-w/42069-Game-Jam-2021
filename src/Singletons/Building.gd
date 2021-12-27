extends Node2D
class_name Building

export (float) var max_health = 10.0

onready var sound = get_node("Sounds/Landing_Sound")
onready var tween = get_node("Tween")
onready var healthbar = get_node("Healthbar")
onready var hitbox = get_node("Hitbox")
onready var upgrade_spots = get_node("Upgrades")

var land_sound = preload("res://assets/Audio/Building General/buildingLanding.wav")
var death_sound = preload("res://assets/Audio/Building General/buildingBroken.wav")
var can_zoom  = false
var camera_pos = Vector2(0,0)
var player = null
var health


func _ready():
	healthbar.set_max(max_health)
	healthbar.set_value(max_health)
	health = max_health
	rotation = get_position().angle()+PI/2
	position = get_position().normalized()*512
	hitbox.connect("body_entered", self, "hitbox_entered")
	


#When using the enter/exit building functions you MUST
#change the parent if you intend it to be enterable
func enter_building(_entering):
	return false


func exit_building():
	pass


func store_item(_item):
	return false

#Useful function for all towers, switches an objects parent while keeping position
func change_parent(changed = null, new_owner = null):
	if changed != null:
		var old_owner = changed.get_parent()
		if new_owner != old_owner:
			var temp = changed.global_transform
			old_owner.remove_child(changed)
			new_owner.add_child(changed)
			changed.global_transform = temp

#despawns, because I'm too dumb to write queue_free() (and we also may want other things)
func despawn():
	queue_free()


func take_damage(_damage = 1):
	_set_health(health - _damage)


func _set_health(value):
	var prev_health = health
	health = clamp(value,0,max_health)
	if health != prev_health:
#		emit_signal("health_updated", health)
		healthbar.set_value(health)
		if health == 0:
			_die()

#Called when the building loses all health, makes the building die
func _die():
	die()
	exit_building()
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(self,"position", 
				get_position(), get_position() + Vector2(0,24).rotated(get_position().angle() + PI/2),4)
	tween.interpolate_property(self,"modulate:a",
				1, 0, 4)
	tween.interpolate_property(self, "rotation", get_rotation(), get_rotation() + PI/4, 4, 
				Tween.EASE_IN, Tween.TRANS_QUINT)
	tween.connect("tween_all_completed", self, "despawn")
	tween.start()

#stop special processes, meant to be overridden 
func die():
	pass

#Building starts, when it's done constructing
func _start(_body, _key):
	healthbar.set_visible(true)
	start()

#Start special processes, meant to be overriden
func start():
	pass


func spawn():
	if !sound.is_playing():
		sound.stream = land_sound
		sound.play()
	start_build()

#Tweens the building up, constructs the building
func start_build():
	tween.interpolate_property(self,"position", 
				get_position() + Vector2(0,24).rotated(get_position().angle() + PI/2), get_position(),4)
	tween.interpolate_property(self,"modulate:a",
				0, 1, 4)
	tween.connect("tween_completed", self, "_start")
	tween.start()

#Hitbox collisions
func hitbox_entered(body):
	if body is Asteroid:
		take_damage(body.damage)

#Handles Upgrades
func upgrade(construct):
	for pos in upgrade_spots.get_children():
		if pos.get_child_count() == 0:
			if !sound.is_playing():
				sound.stream = land_sound
				sound.play()
			var mini_construct = TowerStuff.get_mini_building(construct)
			var new_mini = mini_construct.instance()
			pos.call_deferred("add_child", new_mini)
			return true
	return false
