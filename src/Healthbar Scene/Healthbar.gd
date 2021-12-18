extends VBoxContainer

onready var planet_health_bar = $Planet_Health
onready var stardust_completion_bar = $Stardust_Progress


func set_health(health):
	planet_health_bar.set_value(health)


func get_health():
	return planet_health_bar.get_value()


func set_stardust(stardust):
	stardust_completion_bar.set_value(stardust)


func get_stardust():
	return stardust_completion_bar.get_value()
