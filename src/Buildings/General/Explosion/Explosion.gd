extends Node2D


func _ready():
	global_rotation = get_position().angle()+PI/2
	set_position(get_position().normalized()*GameData.current_level.get_node("Planet").get_radius())
	$AnimatedSprite.play("Explosion")
	$AudioStreamPlayer2D.play()

func _on_AnimatedSprite_animation_finished():
	queue_free()
