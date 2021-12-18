extends Node


var current_level = null
var asteroid_spawner = null
var stardust = 0.0
var planet_health = 100.0
var refinery_count = 0


func set_things(level_node):
	current_level = level_node
	asteroid_spawner = level_node.get_node("AsteroidSpawner")


func reset():
	current_level = null
	asteroid_spawner = null
	stardust = 0.0
	planet_health = 100.0
	refinery_count = 0
