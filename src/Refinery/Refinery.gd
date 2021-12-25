extends Building


var refinery_output = 1

func _ready():
	spawn()


func _physics_process(delta):
	GameData.stardust += refinery_output * delta


func start(_object,_nodePath):
	set_physics_process(true)
	for particle in $Particles.get_children():
		particle.set_emitting(true)




func _on_exception_area_entered(body):
	if body is Projectile:
		body.too_close = true


func _on_exception_area_exited(body):
	if body is Projectile:
		body.too_close = false
