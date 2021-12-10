extends Menu

func _ready():
	mainButton = $Back

func _on_Back_pressed():
	emit_signal("switch_menu", menuKey, "main_menu")
