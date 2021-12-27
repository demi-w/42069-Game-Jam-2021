extends Node2D


func _ready():
	if get_position().length() < GameData.current_level.get_node("Planet").get_radius() + 20:
		global_rotation = get_position().angle()+PI/2
		set_position(get_position().normalized()*GameData.current_level.get_node("Planet").get_radius())
		$AnimatedSprite.play("Surface Explosion")
		$AudioStreamPlayer2D.play()
	else:
		global_rotation = get_position().angle()+PI/2
		$AnimatedSprite.position = Vector2(0,0)
		$AnimatedSprite.play("Air Explosion")
		$AudioStreamPlayer2D.play()

func _on_AnimatedSprite_animation_finished():
	queue_free()
