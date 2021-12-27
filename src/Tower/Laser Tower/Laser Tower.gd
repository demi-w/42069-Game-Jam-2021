extends Tower

onready var laser = $Laser

var target = null
var damage = 10



func _ready():
	laser.set_beam_color(Color(1.00,1.00,0.0,1.00))
	laser.set_particle_color(Color(0.00,1.00,0.00,1.00))
	set_physics_process(true)
	spawn()


func fire(_target):
	target = _target
	if !laser.is_casting:
		laser.is_casting = true
		laser.global_rotation = (target.get_global_position() - laser.get_global_position()).angle()


func _physics_process(delta):
	if _currentlyFiring && is_instance_valid(target):
		laser.global_rotation = (target.get_global_position() - laser.get_global_position()).angle()
		target.take_damage(damage*delta)
	else:
		target = null
		if laser.is_casting == true:
			firing(false)
			laser.is_casting = false


func firing(value):
	if value:
		laser.is_casting = value
		$Laser_Noise.play()
	else:
		laser.is_casting = value
		$Laser_Noise.stop()


func can_fire_at(_body):
	return true


func start():
	pass


func _on_Exception_Area_body_entered(body):
	if body is Projectile:
		body.too_close = true


func _on_Exception_Area_body_exited(body):
	if body is Projectile:
		body.too_close = false

