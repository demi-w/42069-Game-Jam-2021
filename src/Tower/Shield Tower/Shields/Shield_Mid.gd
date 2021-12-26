extends Area2D
class_name Shield

onready var tween = $Tween
onready var timer = $Timer

var max_health = 50.0
var health = 0.0 setget _set_health
var damage = 50.0
var recharge_timer = 5
var recharge_speed = 5



func _ready():
	timer.set_wait_time(recharge_timer)


func start_shield():
	reset_health()


func _on_asteroid_entered(body):
	if body is Asteroid && health != 0:
		body.take_damage(damage)
		take_damage(body.damage)


func take_damage(_damage = 1):
	if tween.is_active():
		tween.stop_all()
	_set_health(health - _damage)
	timer.start()


func _set_health(value):
	var prev_health = health
	health = clamp(value,0,max_health)
	if health != prev_health:
		set_progress()


func set_progress():
	$ColorRect.material.set("shader_param/progress", float(health/max_health))


func reset_health():
	tween.interpolate_property(self, "health", health, max_health, 
				(max_health - health)/recharge_speed)
	tween.start()
