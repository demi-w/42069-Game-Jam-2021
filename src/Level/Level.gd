extends Node2D

const colony = preload("res://src/Planet/Colony/Colony.tscn")

onready var planet = $Planet
onready var raycast = $Planet/RayCast2D
onready var colonyTimer = $Colony_Timer

export (int) var numberOfColonies 

func _ready():
	randomize()
	spawn_colonies()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func spawn_colonies():
	if get_tree().get_nodes_in_group("Colonies").size() < numberOfColonies:
		spawn_colony(rand_range(0, 2 * PI))


func spawn_colony(angle):
	var spawnSpot = Vector2(cos(angle)*512,sin(angle)*512)
	raycast.set_cast_to(spawnSpot)
	raycast.force_raycast_update()
	if !raycast.is_colliding():
		var newColony = colony.instance()
		planet.add_child(newColony)
		newColony.set_position(spawnSpot)
		newColony.set_rotation(angle + PI / 2)
		newColony.add_to_group("Colonies")
	colonyTimer.start()
