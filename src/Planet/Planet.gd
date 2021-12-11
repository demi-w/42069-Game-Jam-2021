tool
extends Node2D
class_name Planet

export var planetScale = 1.0 setget set_scale
onready var planetRadius = $Sprite.get_texture().get_height() * $Sprite.get_scale().x * get_scale().x * 0.5 * planetScale #IDK why, needs to be 0.5 for radius and 0.5 for some scaling shit



func _draw():
	if Engine.is_editor_hint():
		draw_circle(position,planetRadius,Color.red)
	

func set_scale(new_scale):
	planetScale = new_scale
	planetRadius = $Sprite.get_texture().get_height() * $Sprite.get_scale().x * get_scale().x * 0.5 * planetScale
	if Engine.is_editor_hint():
		update()
