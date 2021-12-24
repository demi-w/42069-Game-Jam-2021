extends Node2D

onready var sprite = $Tag
onready var icon = $Tag/Sprite
onready var warning = $Exclamation
onready var timer = $Timer
onready var time_label1 = $Tag/Node2D/Time
onready var time_label2 = $Exclamation/Time

var target_position = null
var time_base = null setget set_time


func _ready():
	warning.set_rotation(get_position().angle()+PI/2)
	if time_base != null:
		set_timer(time_base)
	pass


func set_different_position(_value):
	set_position(_value)
	call_deferred("set_visible_warning")


func set_visible_warning():
	warning.set_visible(true)



#	if (ms % 10) < 10:
#		milisec = "0" + str(ms % 10)
#	else:
#		milisec = str(ms % 10)
#
#	if ((ms / 10) % 60) < 10:
#		sec = "0" + str(((ms / 10) % 60))
#	else:
#		sec = str(((ms / 10) % 60))
#	m = (ms / 10) / 60
#
#	set_text(str(m) + ":" + sec + ":" + milisec)


func set_time(_value):
	time_base = _value


func set_timer(time):
	timer.set_wait_time(time)
	timer.start()
	time_label1.set_visible(true)
	time_label2.set_visible(false)


func _process(_delta):
	target_position = GameData.player.global_position
	var canvas = get_canvas_transform()
	var top_left = -canvas.origin
	var size = get_viewport_rect().size
	set_marker_position(canvas, Rect2(top_left,size))
	set_marker_rotation()
	if !timer.is_stopped():
		var time = int(timer.get_time_left())
		time_label1.set_text(str(time))
		time_label2.set_text(str(time))



#My current problem appears to be with the clamp
#	it doesn't cut off the vector at a certain length but instead cuts down each side


func set_marker_position(transform : Transform2D, bounds : Rect2):
	var new_position = global_position
	new_position = transform.basis_xform(new_position) #To Camera Space
	if bounds.has_point(new_position):
		sprite.hide()
	else:
		sprite.show()
	if target_position == null:
		new_position.x = clamp(new_position.x, bounds.position.x, bounds.end.x)
		new_position.y = clamp(new_position.y, bounds.position.y, bounds.end.y)
	else:
		var new_target_position = transform.basis_xform(target_position)
		var displacement = new_position - new_target_position
		var length

		var tl = (bounds.position - new_target_position).angle()
		var tr = (Vector2(bounds.end.x, bounds.position.y) - new_target_position).angle()
		var bl = (Vector2(bounds.position.x, bounds.end.y) - new_target_position).angle()
		var br = (bounds.end - new_target_position).angle()
		if (displacement.angle() > tl && displacement.angle() < tr) \
				|| (displacement.angle() < bl && displacement.angle() > br):
			var y_length = clamp(displacement.y, bounds.position.y - new_target_position.y,
					bounds.end.y - new_target_position.y)
			var angle = displacement.angle() - PI / 2.0
			length = y_length / cos(angle) if cos(angle) != 0 else y_length
		else:
			var x_length = clamp(displacement.x, bounds.position.x - new_target_position.x,
					bounds.end.x - new_target_position.x)
			var angle = displacement.angle()
			length = x_length / cos(angle) if cos(angle) != 0 else x_length

		new_position = polar2cartesian(length, displacement.angle()) + new_target_position

	new_position = transform.affine_inverse().basis_xform(new_position) #To Game Space
	sprite.global_position = new_position



#func set_marker_position(transform : Transform2D, bounds : Rect2):
#	var new_position = global_position
#	new_position = transform.basis_xform(new_position) #To Camera Space
#
#	if bounds.has_point(new_position):
#		sprite.hide()
#	else:
#		sprite.show()
#	new_position.x = clamp(new_position.x, bounds.position.x, bounds.end.x)
#	new_position.y = clamp(new_position.y, bounds.position.y, bounds.end.y)
#	new_position = transform.affine_inverse().basis_xform(new_position) #To Game Space
#	sprite.global_position = new_position



#func _process(delta):
#	target_position = GameData.player.global_position
#	var canvas = get_canvas_transform()
#	var top_left = -canvas.origin / canvas.get_scale()
#	var size = get_viewport_rect().size / canvas.get_scale()
#	set_marker_position(Rect2(top_left, size))
#	set_marker_rotation()
#
#
#func set_marker_position(bounds : Rect2):
#	if target_position == null:
#		sprite.global_position.x = clamp(global_position.x, bounds.position.x, bounds.end.x)
#		sprite.global_position.y = clamp(global_position.y, bounds.position.y, bounds.end.y)
#	else:
#		var displacement = global_position - target_position
#		var length
#
#		var tl = (bounds.position - target_position).angle()
#		var tr = (Vector2(bounds.end.x, bounds.position.y) - target_position).angle()
#		var bl = (Vector2(bounds.position.x, bounds.end.y) - target_position).angle()
#		var br = (bounds.end - target_position).angle()
#		if (displacement.angle() > tl && displacement.angle() < tr) \
#				|| (displacement.angle() < bl && displacement.angle() > br):
#			var y_length = clamp(displacement.y, bounds.position.y - target_position.y,
#					bounds.end.y - target_position.y)
#			var angle = displacement.angle() - PI / 2.0
#			length = y_length / cos(angle) if cos(angle) != 0 else y_length
#		else:
#			var x_length = clamp(displacement.x, bounds.position.x - target_position.x,
#					bounds.end.x - target_position.x)
#			var angle = displacement.angle()
#			length = x_length / cos(angle) if cos(angle) != 0 else x_length
#
#		sprite.global_position = polar2cartesian(length, displacement.angle()) + target_position
#
#	if bounds.has_point(global_position):
#		hide()
#	else:
#		show()


func set_marker_rotation():
	var angle = (global_position - sprite.global_position).angle()
	sprite.global_rotation = angle
	icon.global_rotation = -get_viewport_transform().get_rotation()
	time_label1.get_parent().rotation = icon.rotation
