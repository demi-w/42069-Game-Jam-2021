extends Node

export var transition_duration = 2


onready var current_stream = $Current_Stream
onready var tween = $Stream_Tweener

var next_stream = null


func start_cross_fade():
	if next_stream != null:
		fade_out(current_stream)
		fade_in(next_stream)
		tween.connect("tween_completed",self,"on_cross_fade_finished", [], CONNECT_ONESHOT)


func on_cross_fade_finished(_object, _key):
	switch_stream()


func set_next_stream(stream_path):
	var music = AudioStreamPlayer.new()
	var stream = load(stream_path)
	add_child(music)
	music.set_stream(stream)
	music.volume_db = -80
	music.pitch_scale = 1
	music.play()
	next_stream = music
	start_cross_fade()


func switch_stream():
	current_stream.queue_free()
	current_stream = next_stream
	next_stream = null


func fade_out(object):
	tween.interpolate_property(object, "volume_db", -10, -80, transition_duration)
	tween.start()


func fade_in(object):
	tween.interpolate_property(object, "volume_db", -80, -10, transition_duration)
	tween.start()


func stop():
	fade_out(current_stream)
