class_name Scrap
extends RigidBody2D

export (int) var scrap_value = 10 setget ,get_scrap_value


func _init(_scrap_value = 10).():
	scrap_value = _scrap_value


func get_scrap_value():
	return scrap_value


func _ready():
	randomize()
	if $Sprite.texture == null:
		scrap_value = ceil(rand_range(5,20))
#	var texture = ImageTexture.new()
#	var image = Image.new()
#	image.load(_get_texture())
#	texture.create_from_image(image)
		$Sprite.set_texture(load(_get_texture()))



func _get_texture():
	if scrap_value < 10:
		return "res://assets/Items/Scrap/Scrap1.png"
	elif scrap_value < 15:
		return "res://assets/Items/Scrap/Scrap2.png"
	else:
		return "res://assets/Items/Scrap/Scrap3.png"
