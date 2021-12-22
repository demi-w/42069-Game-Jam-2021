extends Node

const prediction_flag = preload("res://src/Healthbar Scene/UI Warnings/Offscreen Marker.tscn")

var current_level = null
var asteroid_spawner = null
var player = null
var stardust = 0.0
var planet_health = 100.0
var refinery_count = 0
var scrap = 0

func set_things(level_node, _player):
	current_level = level_node
	asteroid_spawner = level_node.get_node("AsteroidSpawner")
	player = _player


func reset():
	current_level = null
	asteroid_spawner = null
	stardust = 0.0
	planet_health = 100.0
	refinery_count = 0
	player = null
