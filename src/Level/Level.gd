extends Node2D

const colony = preload("res://src/Planet/Colony/Colony.tscn")

onready var planet = $Planet

func _ready():
	spawn_colony(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rand_range(0, 2*PI)

func spawn_colonies():
	pass


func spawn_colony(angle):
	var newColony = colony.instance()
	planet.add_child(newColony)
	newColony.set_position(Vector2(cos(angle)*512,sin(angle)*512))
	newColony.set_rotation(angle + PI / 2)
	newColony.add_to_group("Colonies")


#		var newTower = tower.instance()
#		var texture = get_node(@"Sprite").get_texture()
#		body.add_child(newTower)
#		newTower.set_rotation(body.get_node(@"Sprite").get_rotation())
#		newTower.set_position(Vector2(0,-16))
#		newTower.get_node(@"Sprite").set_texture(texture)
