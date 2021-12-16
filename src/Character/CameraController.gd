extends Camera2D

var zoomMin = Vector2(0.25, 0.25)
var zoomMax = Vector2(2, 2)
var zoomSpeed = Vector2(.25, .25)


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				if zoom > zoomMin:
					zoom -= zoomSpeed
					position -= Vector2(0,20)
			if event.button_index == BUTTON_WHEEL_DOWN:
				if zoom < zoomMax:
					zoom += zoomSpeed
					position += Vector2(0,20)


func switch_to_building(player, building):
	player.remove_child(self)
	building.add_child(self)
	set_position(get_position()+building.camera_pos.get_position())


func switch_to_player(player, building):
	set_position(get_position()-building.camera_pos.get_position())
	building.remove_child(self)
	player.add_child(self)

