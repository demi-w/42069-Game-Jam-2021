extends Building


var scrap_force = Vector2(-40,-40)
var scrap_force_offset = Vector2(0,-10)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Player/Camera")._set_current(true)
	get_node("Player").enter_building(self)
	player = get_node("Player")
	player.call_deferred("enter_building",self)
	yield(get_tree().create_timer(3),"timeout")
	throw_scrap()


func _input(_event):
	if Input.is_action_just_pressed("interact") && player != null:
		exit_building()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func enter_building(entered):
	return true

func exit_building():
	player.leave_building(self)
	player.set_mode(0)
	change_parent(player, get_parent())
	print(player.get_parent())
	player = null
	yield(get_tree().create_timer(3),"timeout")
	despawn()
	


func throw_scrap():
	var left_door = $Left_Door
	var right_door = $Right_Door
	var rotPosition = get_position().angle()+PI/2
	change_parent(left_door, get_parent())
	change_parent(right_door, get_parent())
	if left_door != null:
		left_door.apply_impulse(scrap_force_offset.rotated(rotPosition),scrap_force.rotated(rotPosition))
	if right_door != null:
		right_door.apply_impulse(scrap_force_offset.rotated(rotPosition),Vector2(-scrap_force.x,scrap_force.y).rotated(rotPosition))


func change_layer(body, scrap):
	scrap.set_z_index(0)


func despawn():
	queue_free()
