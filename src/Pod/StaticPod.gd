extends StaticBody2D


var scrap_force = Vector2(-60,-60)
var scrap_force_offset = Vector2(0,-10)

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(3),"timeout")
	throw_scrap()
	print("yeet")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func throw_scrap():
	var left_door = $Left_Door
	var right_door = $Right_Door
	var rotPosition = get_position().angle()+PI/2
	change_parent(left_door)
	change_parent(right_door)
	left_door.apply_impulse(scrap_force_offset.rotated(rotPosition),scrap_force.rotated(rotPosition))
	right_door.apply_impulse(scrap_force_offset.rotated(rotPosition),Vector2(-scrap_force.x,scrap_force.y).rotated(rotPosition))

func change_parent(changed = null):
	var temp = changed.global_transform
	var parent = get_parent()
	remove_child(changed)
	parent.add_child(changed)
	changed.global_transform = temp
