extends Building

signal refinery_added()


onready var sound = $Loading_Noise


func _ready():
	connect("refinery_added", GameData.current_level, "added_refinery", [], CONNECT_ONESHOT)
	rotation = get_position().angle()+PI/2
	position = get_position().normalized()*512
	emit_signal("refinery_added")
	spawn()


func spawn():
	if !sound.is_playing():
		sound.stream = land_sound
		sound.play()


func _on_exception_area_entered(body):
	print(body)
	if body is Projectile:
		body.too_close = true


func _on_exception_area_exited(body):
	if body is Projectile:
		body.too_close = false
