extends Menu


onready var levelOne = $HBoxContainer/Level_1

func _ready():
	mainButton = $Back


func _on_Back_pressed():
	emit_signal("switch_menu", menuKey, "main_menu")


func _on_Level_1_pressed():
	print(get_tree().get_current_scene())
	var root = get_tree().get_current_scene()
	var currentLevel = root.get_node("Menu")
	root.remove_child(currentLevel)
	currentLevel.call_deferred("free")
	
	var next_level_resource = load("INSERT LEVEL HERE")
	var next_level = next_level_resource.instance()
	root.add_child(next_level)
