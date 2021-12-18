extends Node2D
class_name Building

var can_zoom  = false
var camera_pos = Vector2(0,0)
var player = null

#When using the enter/exit building functions you MUST
#change the parent if you intend it to be enterable
func enter_building(entering):
	return false


func exit_building():
	pass


func store_item(item):
	return false


func change_parent(changed = null, new_owner = null):
	if changed != null:
		var old_owner = changed.get_parent()
		if new_owner != old_owner:
			var temp = changed.global_transform
			old_owner.remove_child(changed)
			new_owner.add_child(changed)
			changed.global_transform = temp
