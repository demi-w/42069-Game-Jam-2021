extends Node2D

onready var sprite = $Sprite
onready var icon = $Sprite/Sprite

var target_position = null


func _process(delta):
	target_position = GameData.player.global_position
	var canvas = get_canvas_transform()
	var top_left = -canvas.origin
	var size = get_viewport_rect().size
	set_marker_position(canvas, top_left, size)
	set_marker_rotation()




func set_marker_position(transform : Transform2D, top_left, size):
	var viewport_size = get_viewport_rect().size
	var new_position = global_position
	new_position = transform.basis_xform(new_position)
	if Rect2(top_left,size).has_point(new_position):
		hide()
	else:
		show()
	new_position.x = clamp(new_position.x, top_left.x, top_left.x + size.x)
	new_position.y = clamp(new_position.y, top_left.y, top_left.y + size.y)
	new_position = transform.affine_inverse().basis_xform(new_position)
	sprite.global_position = new_position



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
	icon.global_rotation = 0
