extends Scrap

func _ready():
	randomize()
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
