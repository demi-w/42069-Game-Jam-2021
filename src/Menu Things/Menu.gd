extends Control

signal switch_scene(next_scene)

onready var mainMenu = $Background/Main_Menu
onready var levelSelect = $Background/Level_Select
onready var credits = $Background/Credits
onready var tween = $Tween
onready var background = $Background
onready var camera = $Camera

onready var basic_rect = Rect2(0,0,1024,600)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print(get_viewport_rect().size/basic_rect.size)
	var viewport_rect_size = get_viewport_rect().size
	camera.zoom.x = 1 / (viewport_rect_size.x / basic_rect.size.x)
	camera.zoom.y = 1 / (viewport_rect_size.y / basic_rect.size.y)


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
		"credits":
			return credits


func _on_Level_Select_change_scene(next_scene):
	emit_signal("switch_scene", next_scene)
