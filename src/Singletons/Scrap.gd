class_name Scrap
extends RigidBody2D

var scrap_value = 10 setget ,get_scrap_value


func _init(_scrap_value = 10).():
	scrap_value = _scrap_value


func get_scrap_value():
	return scrap_value
