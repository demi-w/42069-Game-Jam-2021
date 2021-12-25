extends Control

signal switch_scene(next_scene)

var base_scale = Vector2(6.827,7.143)

func _on_Back_pressed():
	var next_level_resource = load("res://src/Menu Things/Menu.tscn") 
	emit_signal("switch_scene", next_level_resource)
