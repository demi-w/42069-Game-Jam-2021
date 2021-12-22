extends Node


onready var current_level = $Current_Scene/Menu


var next_scene = null


func _process(_delta):
	if next_scene != null:
		$TransitionScene.transition()


func _on_TransitionScene_transitioned():
	current_level.queue_free()
	$Current_Scene.add_child(next_scene.instance())
	next_scene = null


func _on_Menu_switch_scene(_next_scene):
	next_scene = _next_scene
