extends MiniTower


onready var laser = $Laser


var target = null
var damage = 5


func _ready():
	laser.set_beam_color(Color(1.00,1.00,0.0,1.00))
	laser.set_particle_color(Color(0.00,1.00,0.00,1.00))
	spawn()


func fire(_target):
	target = _target
	if !laser.is_casting:
		laser.is_casting = true
		set_physics_process(true)
		laser.global_rotation = (target.get_global_position() - laser.get_global_position()).angle()
	


func _physics_process(delta):
	if _currentlyFiring && is_instance_valid(target):
		laser.global_rotation = (target.get_global_position() - laser.get_global_position()).angle()
		target.take_damage(damage*delta)
	else:
		target = null
		if laser.is_casting == true:
			laser.is_casting = false


#func _physics_process(delta):
#	if target_dict.size() > 0:
#		if target_dict[0] != null:
#			laser.global_rotation = (target_dict[0].get_global_position() - laser.get_global_position()).angle()
#			target_dict[0].take_damage(damage * delta)
#		else:
#			target_dict.remove(0)
#	else:
#		if laser.is_casting != false:
#			laser.is_casting = false


func can_fire_at(body):
	return true


func start():
	pass


func _on_Exception_Area_body_entered(body):
	if body is Projectile:
		body.too_close = true


func _on_Exception_Area_body_exited(body):
	if body is Projectile:
		body.too_close = false

