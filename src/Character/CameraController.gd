extends Camera2D

var zoomMin = Vector2(0.25, 0.25)
var zoomMax = Vector2(2, 2)
var zoomSpeed = Vector2(.25, .25)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				if zoom > zoomMin:
					zoom -= zoomSpeed
					if get_parent() is Player:
						position -= Vector2(0,20)
			if event.button_index == BUTTON_WHEEL_DOWN:
				if zoom < zoomMax:
					zoom += zoomSpeed
					if get_parent() is Player:
						position += Vector2(0,20)
