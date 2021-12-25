extends Tower

onready var laser = $Laser

var target_dict = []
var damage = 5

func _ready():
	spawn()


func fire(_target):
	if !target_dict.has(_target):
		target_dict.append(_target)
		laser.is_casting = true
		laser.global_rotation = (target_dict[0].get_global_position() - get_global_position()).angle() + PI/2


func _physics_process(delta):
	if target_dict.size() > 0:
		laser.global_rotation = (target_dict[0].get_global_position() - laser.get_global_position()).angle()
		target_dict[0].take_damage(damage * delta)
		if target_dict[0].is_queued_for_deletion():
			target_dict.remove(0)
	else:
		if laser.is_casting != false:
			laser.is_casting = false


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


func _on_Area2D_body_exited(body):
	if target_dict.has(body):
		target_dict.remove(target_dict.find(body))
