extends Menu

signal change_scene(next_scene)

onready var levelOne = $HBoxContainer/Level_1

func _ready():
	mainButton = $Back


func _on_Back_pressed():
	emit_signal("switch_menu", menuKey, "main_menu")


func _on_Level_1_pressed():
	var next_level_resource = load("res://src/Level/Level1/Level1.tscn")
	emit_signal("change_scene", next_level_resource)
