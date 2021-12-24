extends Node

const prediction_flag = preload("res://src/Healthbar Scene/UI Warnings/Offscreen Marker.tscn")

var current_level = null
var asteroid_spawner = null
var player = null
var stardust = 0.0
var planet_health = 100.0 setget _set_planet_health
var refinery_count = 0
var scrap = 0

var _planet_healthbar = null

func set_things(level_node, _player):
	current_level = level_node
	asteroid_spawner = level_node.get_node("AsteroidSpawner")
	player = _player
	_planet_healthbar = level_node.get_node("CanvasLayer").get_node("Healthbar")

func _set_planet_health(value):
	_planet_healthbar.set_health(value)
	planet_health = value
	
func _set_stardust(value):
	_planet_healthbar.set_stardust(value)
	stardust = value

func reset():
	current_level = null
	asteroid_spawner = null
	stardust = 0.0
	planet_health = 100.0
	refinery_count = 0
	player = null
