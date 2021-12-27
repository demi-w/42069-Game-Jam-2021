extends Area2D
class_name MiniShield


onready var tween = $Tween
onready var timer = $Timer
onready var parent = get_parent()
onready var particles = $Particles2D

var base_color = Color(0.00,0.66,0.09,1.00)
var max_health = 20.0
var health = 0.0 setget _set_health
var damage = 25.0
var recharge_timer = 5
var recharge_speed = 5



func _ready():
	timer.set_wait_time(recharge_timer)
	set_recharge_particles()


func start_shield():
	reset_health()


func stop_shield():
	health = 0


func _on_asteroid_entered(body):
	if body is Asteroid && health != 0:
		body.take_damage(damage)
		take_damage(body.damage)


func take_damage(_damage = 1):
	if tween.is_active():
		particles.set_emitting(false)
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


func set_recharge_particles():
	particles.global_position = parent.get_global_position()
	particles.global_rotation = (get_global_position() - parent.get_global_position()).angle() + PI



func reset_health():
	tween.interpolate_property(self, "health", health, max_health, 
				(max_health - health)/recharge_speed)
	particles.set_emitting(true)
	tween.start()


func _on_Tween_tween_all_completed():
	particles.set_emitting(false)
