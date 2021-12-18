extends Building

signal refinery_added()


func _ready():
	connect("refinery_added", GameData.current_level, "added_refinery", [], CONNECT_ONESHOT)
	rotation = get_position().angle()+PI/2
	position = get_position().normalized()*512
	emit_signal("refinery_added")

