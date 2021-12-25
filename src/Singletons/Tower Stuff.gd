extends Node


const launcher = preload("res://src/Launcher/Launcher.tscn")
const refinery = preload("res://src/Refinery/Refinery.tscn")
const laser_tower = preload("res://src/Tower/Laser Tower/Laser Tower.tscn")
const scrap_collector = preload("res://src/Tower/Scrap Collector/Scrap Collector.tscn")

func get_building(key):
	match key:
		"Refinery":
			return refinery
		"Launcher":
			return launcher
		"Laser Tower":
			return laser_tower
		"Scrap Collector":
			return scrap_collector


func get_building_color(building):
	if building != null:
		match building:
			refinery:
				return Color.yellow
			launcher:
				return Color.orange
			laser_tower:
				return Color.green
			scrap_collector:
				return Color.violet


func get_building_secondary_color(building):
	if building != null:
		match building:
			refinery:
				return Color.palegoldenrod
			launcher:
				return Color.blueviolet
			laser_tower:
				return Color.limegreen
			scrap_collector:
				return Color.purple


func get_building_cost(building):
	if building is PackedScene:
		match building:
			refinery:
				return 20
			launcher:
				return 5
			laser_tower:
				return 15
			scrap_collector:
				return 10
	elif building is String:
		match building:
			"Refinery":
				return 20
			"Launcher":
				return 5
			"Laser Tower":
				return 15
			"Scrap Collector":
				return 10
