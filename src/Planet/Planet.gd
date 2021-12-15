tool
extends Node2D
class_name Planet

export var planetScale = 1.0 setget set_scale
onready var planetRadius = $Planet_Radius.get_shape().get_radius()


func _draw():
	if Engine.is_editor_hint():
		draw_circle(position,planetRadius,Color.red)
	

func set_scale(new_scale):
	planetRadius = $Planet_Radius.get_shape().get_radius()
	print(planetRadius)
	if Engine.is_editor_hint():
		update()
