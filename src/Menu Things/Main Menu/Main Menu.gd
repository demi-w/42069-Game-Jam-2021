extends Menu

onready var playButton = $Play
onready var parent = get_parent()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	mainButton = $Play


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Play_pressed():
	emit_signal("switch_menu", "main_menu", "level_select")
	


func _on_Exit_pressed():
	get_tree().quit()


func _on_Options_pressed():
	emit_signal("switch_menu", menuKey, "options")
