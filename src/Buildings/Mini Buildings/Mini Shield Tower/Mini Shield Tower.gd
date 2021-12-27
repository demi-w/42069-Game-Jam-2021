extends MiniBuilding


onready var shield_list = $Shields


func _ready():
	spawn()


func die():
	for shield in shield_list.get_children():
		shield.stop_shield()


func start():
	$Particles2D.set_emitting(true)
	for shield in shield_list.get_children():
		shield.start_shield()
	if get_parent().position.x != 0:
		shield_list.rotation = get_parent().position.x/abs(get_parent().position.x) * PI/4
