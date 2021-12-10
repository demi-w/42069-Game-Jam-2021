extends Control


onready var mainMenu = $Background/Main_Menu
onready var levelSelect = $Background/Level_Select
onready var tween = $Tween
onready var background = $Background
onready var camera = $Camera
var options = null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func switch_menu(calling_menu, switched_menu):
	if !tween.is_active():
		var switchMenu = get_area(switched_menu)
		tween.interpolate_property(camera, "position", 
				camera.get_position(), switchMenu.rect_position + switchMenu.rect_pivot_offset, 2,
				2, 0)
		tween.start()
		switchMenu.open()
#	tween.interpolate_property(center_cont, "rect_position",
#			_start_position, _end_position, fade_in_duration,
#			Tween.TRANS_CUBIC, Tween.EASE_OUT)

func get_area(key):
	match key:
		"main_menu":
			return mainMenu
		"level_select":
			return levelSelect
		"options":
			return options
