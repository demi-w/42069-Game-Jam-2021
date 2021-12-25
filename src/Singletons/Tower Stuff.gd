extends Node


const launcher = preload("res://src/Launcher/Launcher.tscn")
const refinery = preload("res://src/Refinery/Refinery.tscn")
const laser_tower = preload("res://src/Tower/Laser Tower/Laser Tower.tscn")


func get_building(key):
	match key:
		"Refinery":
			return refinery
		"Launcher":
			return launcher
		"Laser Tower":
			return laser_tower


func get_building_color(building):
	if building != null:
		match building:
			refinery:
				return Color.yellow
			launcher:
				return Color.purple
			laser_tower:
				return Color.green


func get_building_secondary_color(building):
	if building != null:
		match building:
			refinery:
				return Color.palegoldenrod
			launcher:
				return Color.blueviolet
			laser_tower:
				return Color.limegreen


func get_building_cost(building):
	if building is PackedScene:
		match building:
			refinery:
				return 20
			launcher:
				return 5
			laser_tower:
				return 15
	elif building is String:
		match building:
			"Refinery":
				return 20
			"Launcher":
				return 5
			"Laser Tower":
				return 15
