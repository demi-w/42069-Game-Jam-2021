extends Node2D
class_name Planet

onready var planetRadius = $Sprite.get_texture().get_height() * $Sprite.get_scale().x * 0.5
