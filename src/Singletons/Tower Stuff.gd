extends Node

#Full buildings
const launcher = preload("res://src/Launcher/Launcher.tscn")
const refinery = preload("res://src/Refinery/Refinery.tscn")
const laser_tower = preload("res://src/Tower/Laser Tower/Laser Tower.tscn")
const scrap_collector = preload("res://src/Tower/Scrap Collector/Scrap Collector.tscn")
const shield_tower = preload("res://src/Tower/Shield Tower/Shield Tower.tscn")

#Mini buildings
const mini_launcher = preload("res://src/Buildings/Mini Buildings/Mini Launcher/Mini Launcher.tscn")
const mini_refinery = preload("res://src/Buildings/Mini Buildings/Mini Refinery/Mini Refinery.tscn")
const mini_laser_tower = preload("res://src/Buildings/Mini Buildings/Mini Laser Tower/Mini Laser Tower.tscn")
const mini_scrap_collector = preload("res://src/Buildings/Mini Buildings/Mini Scrap/Mini Scrap Collector.tscn")
const mini_shield_tower = preload("res://src/Buildings/Mini Buildings/Mini Shield Tower/Mini Shield Tower.tscn")



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
		"Shield Tower":
			return shield_tower


func get_mini_building(key):
	match key:
		refinery:
			return mini_refinery
		launcher:
			return mini_launcher
		laser_tower:
			return mini_laser_tower
		scrap_collector:
			return mini_scrap_collector
		shield_tower:
			return mini_shield_tower


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
			shield_tower:
				return Color.aqua


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
			shield_tower:
				return Color.blue


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
			shield_tower:
				return 15
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
			"Shield Tower":
				return 15
