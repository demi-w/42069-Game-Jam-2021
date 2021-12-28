extends Tower

onready var field = $Gravity_Area
onready var field_tween = $Field_Tween

var in_chute = []
var target = null

var target_destination

func _ready():
	spawn()


func die():
	field.is_pulling = false


func fire(_target):
	target = _target
	if !field_tween.is_active():
		move_gravity(to_local(target.get_global_position()), $Scrap_Chute.get_position())
		field.is_pulling = true
		for particle in $Particles.get_children():
			particle.set_emitting(true)


func _physics_process(_delta):
	if _currentlyFiring && is_instance_valid(target):
		if !field_tween.is_active():
			move_gravity(to_local(target.get_global_position()), $Scrap_Chute.get_position())
			field.is_pulling = true
	else:
		if field.is_pulling != false:
			for particle in $Particles.get_children():
				particle.set_emitting(false)
			field.is_pulling = false


func move_gravity(_start: Vector2, _destination: Vector2):
	field_tween.interpolate_property(field, "position", _start, _destination,
	abs((_destination - _start).length())/field.move_speed)
	field_tween.connect("tween_completed", self, "complete", [], CONNECT_ONESHOT)
	field_tween.start()


func complete(_body, _key):
	for i in in_chute.size():
		in_chute[i].set_linear_velocity(Vector2(0,-20).rotated(get_position().angle()+PI/2))

#This is the coolest piece of code I will ever write
func can_fire_at(body):
	return !body.collected if (body is Scrap) else false

func start():
	pass


func _on_Exception_Area_body_entered(body):
	if body is Projectile:
		body.too_close = true


func _on_Exception_Area_body_exited(body):
	if body is Projectile:
		body.too_close = false


#This body is to make sure we dont target scrap above us
func _on_Scrap_Chute_body_entered(body):
	if body is Scrap:
		body.collected = true
		if !in_chute.has(body):
			in_chute.append(body)


func _on_Scrap_Chute_body_exited(body):
	if body is Scrap:
		body.collected = false
		if in_chute.has(body):
			in_chute.remove(in_chute.find(body))

# For some fucking reason, scrap needs to have its OWN AREA2D IN ORDER TO BE PICKED UP CORRECTLY
#I DON'T EVEN KNOW ANYMORE, IT'S 2:
func _on_scrap_entered(body):
	if body is Scrap:
		GameData.scrap += body.get_scrap_value()
		body.queue_free()
