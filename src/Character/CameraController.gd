extends Camera2D

var zoomMin = Vector2(0.25, 0.25)
var zoomMax = Vector2(2.0, 2.0)
var zoomSpeed = Vector2(.25, .25)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if get_parent().can_zoom:
			if event.is_pressed():
				if event.button_index == BUTTON_WHEEL_UP:
					if zoom > zoomMin:
						zoom -= zoomSpeed
						position -= Vector2(0,20)
				if event.button_index == BUTTON_WHEEL_DOWN:
					if zoom < zoomMax:
						zoom += zoomSpeed
						position += Vector2(0,20)
		else:
			zoom = Vector2(0.25,0.25)
			position = Vector2(0,-40)


func switch_to_building(player, building):
	if get_parent() == player:
		player.remove_child(self)
		building.add_child(self)
		set_position(get_position()+building.camera_pos)


func switch_to_player(player, building):
	if get_parent() == building:
		set_position(get_position()-building.camera_pos)
		building.remove_child(self)
		player.add_child(self)

