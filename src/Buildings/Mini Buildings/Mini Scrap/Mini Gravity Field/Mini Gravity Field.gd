extends Area2D


var is_pulling = false setget set_pulling
var move_speed = 25


func set_pulling(_value):
	is_pulling = _value
	
	if is_pulling:
		set_gravity_is_point(true)
		$Particles2D.set_emitting(true)
	else:
		set_gravity_is_point(false)
		$Particles2D.set_emitting(false)


func _on_Gravity_Area_body_entered(body):
	body.apply_central_impulse((body.get_global_position() - get_global_position()).normalized()*20)
