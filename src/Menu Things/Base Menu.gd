extends Node
class_name Menu

# Any class inheriting this class should declare a mainButton in the _ready() function
#
#

signal switch_menu(calling_scene, target_scene)

export (String) var menuKey = null

onready var mainButton = null

func open():
	if mainButton != null:
		mainButton.grab_focus()
