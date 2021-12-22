extends Building

signal refinery_added()


onready var sound = $Loading_Noise
onready var tween = $Tween

func _ready():
	connect("refinery_added", GameData.current_level, "added_refinery", [], CONNECT_ONESHOT)
	rotation = get_position().angle()+PI/2
	position = get_position().normalized()*512
	spawn()


func start(_object,_nodePath):
	emit_signal("refinery_added")
	for particle in $Particles.get_children():
		particle.set_emitting(true)


func spawn():
	if !sound.is_playing():
		sound.stream = land_sound
		sound.play()
	start_build()


func start_build():
	tween.interpolate_property(self,"position", 
				get_position() + Vector2(0,32).rotated(get_position().angle() + PI/2), get_position(),4)
	tween.interpolate_property(self,"modulate:a",
				0, 1, 4)
	tween.connect("tween_completed", self, "start")
	tween.start()


func _on_exception_area_entered(body):
	if body is Projectile:
		body.too_close = true


func _on_exception_area_exited(body):
	if body is Projectile:
		body.too_close = false
