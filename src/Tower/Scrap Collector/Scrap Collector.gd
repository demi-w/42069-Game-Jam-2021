extends Tower

onready var field = $Gravity_Area

var target_dict = []
var in_chute = []

var target_destination

func _ready():
	spawn()


func fire(_target):
	if !target_dict.has(_target) && !in_chute.has(_target):
		target_dict.append(_target)
#		if !tween.is_active():
		if !tween.is_active():
			move_gravity(to_local(target_dict[0].get_global_position()), $Scrap_Chute.get_position())
			field.is_pulling = true


func _physics_process(delta):
	if target_dict.size() > 0:
		while !target_dict[0] is Scrap && target_dict.size() > 0:
			target_dict.remove(0)
		
		if !tween.is_active() && target_dict.size() > 0:
			if !field.is_pulling:
				field.is_pulling = true
			move_gravity(to_local(target_dict[0].get_global_position()), $Scrap_Chute.get_position())
	elif tween.is_active():
		pass
	else:
		if field.is_pulling != false:
			field.is_pulling = false
			pass


func move_gravity(_start: Vector2, _destination: Vector2):
	tween.interpolate_property(field, "position", _start, _destination,
	abs((_destination - _start).length())/field.move_speed)
	tween.connect("tween_completed", self, "complete", [], CONNECT_ONESHOT)
	tween.start()


func complete(_body, _key):
	print(in_chute)
	for i in in_chute.size():
		in_chute[i].set_linear_velocity(Vector2(0,-20).rotated(get_position().angle()+PI/2))


func can_fire_at(body):
	return true


func start():
	pass


func _on_Exception_Area_body_entered(body):
	if body is Projectile:
		body.too_close = true


func _on_Exception_Area_body_exited(body):
	if body is Projectile:
		body.too_close = false

func _on_Area2D_body_exited(body):
	if target_dict.has(body):
		target_dict.remove(target_dict.find(body))

#This body is to make sure we dont target scrap above us
func _on_Scrap_Chute_body_entered(body):
	if !in_chute.has(body):
		in_chute.append(body)
		target_dict.remove(target_dict.find(body))


func _on_Scrap_Chute_body_exited(body):
	if in_chute.has(body):
		in_chute.remove(in_chute.find(body))

# For some fucking reason, scrap needs to have its OWN AREA2D IN ORDER TO BE PICKED UP CORRECTLY
#I DON'T EVEN KNOW ANYMORE, IT'S 2:23 AM WTF
func _on_scrap_entered(body):
	if body is Scrap:
		GameData.scrap += body.get_scrap_value()
		body.queue_free()
