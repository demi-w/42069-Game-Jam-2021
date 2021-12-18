extends HBoxContainer

signal launch_pressed()
signal predict_pressed(predicting)
signal leave_pressed()

onready var strength = $Strength
onready var angle = $VBoxContainer/Angle

var predicting = false


func set_strength(value):
	strength.set_value(75-value)


func set_angle(value):
	angle.set_value(value)


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

