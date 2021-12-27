extends Node2D
class_name MiniBuilding


onready var tween = get_node("MiniBuilding_Stuff/Tween")


#for spawning
func _start(_body, _key):
	start()

func start():
	pass

func spawn():
	start_build()


func start_build():
	tween.interpolate_property(self,"position", 
				get_position() + Vector2(0,-24).rotated(get_position().angle()), get_position(),4)
	tween.interpolate_property(self,"modulate:a",
				0, 1, 4)
	tween.connect("tween_completed", self, "_start")
	tween.start()
