extends Node


onready var current_level = $Current_Scene/Menu
onready var music_player = $Music_Player

var next_scene = null


func _on_TransitionScene_transitioned():
	current_level.queue_free()
	var _next_scene = next_scene.instance()
	$Current_Scene.add_child(_next_scene)
	_next_scene.connect("switch_scene", self, "on_switch_scene")
	next_scene = null
	current_level = _next_scene


func on_switch_scene(_next_scene):
	var check_instance = _next_scene.instance()
	if check_instance is Level:
		music_player.base_volume = -30
		music_player.set_next_stream("res://assets/Audio/Music/levelMusic.wav")
	elif check_instance is Control:
		music_player.set_next_stream("res://assets/Audio/Music/mainMenu.wav")
		music_player.base_volume = -20
	else:
		music_player.stop()
	next_scene = _next_scene
	$TransitionScene.transition()
	check_instance.free()
