extends Menu

func _ready():
	mainButton = $PlaceHolder

func _on_Back_pressed():
	emit_signal("switch_menu", menuKey, "main_menu")
