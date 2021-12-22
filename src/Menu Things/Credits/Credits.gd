extends Menu


func _ready():
	mainButton = $Back


func on_back_pressed():
	emit_signal("switch_menu", menuKey, "main_menu")
