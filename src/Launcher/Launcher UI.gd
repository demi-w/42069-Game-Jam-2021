extends HBoxContainer

signal launch_pressed()
signal predict_pressed(predicting)
signal leave_pressed()

#for throw
var launch_pos = Vector2(0,-25)
var strength_dir = 0
var angle_dir = 0

onready var strength = $Strength
onready var angle = $VBoxContainer/Angle

var predicting = false



func _update_strength_dir():
	strength_dir = Input.get_action_strength("up") - Input.get_action_strength("down")


func _update_angle_dir():
	angle_dir = Input.get_action_strength("right") - Input.get_action_strength("left")

#values are reversed for some reason (Vscrolls are upside down)
func _set_strength():
	if strength_dir != 0:
		if strength_dir < 0:
			if strength.get_value() < strength.get_max():
				strength.set_value(strength.get_value()+strength.get_step())
		elif strength_dir > 0:
			if strength.get_value() > strength.get_min():
				strength.set_value(strength.get_value()-strength.get_step())


func _set_angle():
	if angle_dir != 0:
		if angle_dir > 0:
			if angle.get_value() < angle.get_max():
				angle.set_value(angle.get_value()-angle.get_step())
		elif angle_dir < 0:
			if angle.get_value() > angle.get_min():
				angle.set_value(angle.get_value()+angle.get_step())


func _handle_aim():
	var last_launch_pos = launch_pos
	_update_angle_dir()
	_update_strength_dir()
	_set_strength()
	_set_angle()
	launch_pos = (launch_pos.normalized()*_get_strength()).rotated(-(launch_pos.angle()-_get_angle()))
	print(launch_pos.angle()-_get_angle())


func get_aim():
	_handle_aim()
	return launch_pos


func _get_strength():
	return 75-strength.get_value()


func _get_angle():
	return angle.get_value()


func _launch():
	emit_signal("launch_pressed")


func _predict():
	predicting = not predicting
	if predicting:
		get_node("VBoxContainer/Predict|EndPredict").set_text("End")
	else:
		get_node("VBoxContainer/Predict|EndPredict").set_text("Predict")
	emit_signal("predict_pressed",predicting)


func _leave():
	emit_signal("leave_pressed")


func open():
	set_visible(true)
	for child in $VBoxContainer.get_children():
		if child is Button:
			child.call_deferred("set_disabled", false)


func close():
	set_visible(false)
	for child in $VBoxContainer.get_children():
		if child is Button:
			child.call_deferred("set_disabled", true)
