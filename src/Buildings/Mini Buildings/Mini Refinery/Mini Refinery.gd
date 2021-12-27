extends MiniBuilding


var refinery_output = 0.5

func _ready():
	set_physics_process(false)
	spawn()


func _physics_process(delta):
	GameData.stardust += refinery_output * delta


func start():
	set_physics_process(true)
	for particle in $Particles.get_children():
		particle.set_emitting(true)

func die():
	set_physics_process(false)
	for particle in $Particles.get_children():
		particle.set_emitting(false)
