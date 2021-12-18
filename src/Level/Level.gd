extends Node2D

const factory = preload("res://src/Factory/Factory.tscn")

onready var planet = $Planet
onready var HUD = $CanvasLayer/Healthbar

export (int) var number_of_factories

func _ready():
	GameData.set_things(self)
	spawn_factories()
	start_coroutine()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func added_refinery():
	GameData.refinery_count += 1


func spawn_factories():
	for i in number_of_factories:
		spawn_factory(i * (2*PI / number_of_factories))


func spawn_factory(angle):
	var spawnSpot = Vector2(cos(angle) * 512, sin(angle)*512)
	var new_factory = factory.instance()
	planet.add_child(new_factory)
	new_factory.set_position(spawnSpot)
	new_factory.set_rotation(angle + PI/2)
	new_factory.add_to_group("Factories")


func start_coroutine():
	while HUD.get_health() > 0 || HUD.get_stardust() < 100:
		GameData.stardust += GameData.refinery_count
		if GameData.stardust != HUD.get_stardust():
			HUD.set_stardust(GameData.stardust)
		if GameData.planet_health != HUD.get_health():
			HUD.set_health(GameData.planet_health)
		yield(get_tree().create_timer(1), "timeout")

#func spawn_colonies():
#	if get_tree().get_nodes_in_group("Colonies").size() < numberOfColonies:
#		spawn_colony(rand_range(0, 2 * PI))
#
#
#func spawn_colony(angle):
#	var spawnSpot = Vector2(cos(angle)*512,sin(angle)*512)
#	raycast.set_cast_to(spawnSpot)
#	raycast.force_raycast_update()
#	if !raycast.is_colliding():
#		var newColony = factory.instance()
#		planet.add_child(newColony)
#		newColony.set_position(spawnSpot)
#		newColony.set_rotation(angle + PI / 2)
#		newColony.add_to_group("Colonies")
#	colonyTimer.start()
