tool
extends Node2D
class_name Planet

onready var planetCollision = $Planet_Radius

var planetRadius setget set_radius, get_radius


func _draw():
	if Engine.is_editor_hint():
		draw_circle(position,planetRadius,Color.red)


func set_radius(value):
	planetRadius = $Planet_Radius.get_shape().get_radius()


func get_radius():
	return $Planet_Radius.get_shape().get_radius()
