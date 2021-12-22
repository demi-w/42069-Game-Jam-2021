extends Node


onready var current_level = $Current_Scene/Menu


var next_scene = null


func _on_TransitionScene_transitioned():
	current_level.queue_free()
	var _next_scene = next_scene.instance()
	$Current_Scene.add_child(_next_scene)
	_next_scene.connect("switch_scene", self, "on_switch_scene")
	next_scene = null


func on_switch_scene(_next_scene):
	next_scene = _next_scene
	$TransitionScene.transition()
