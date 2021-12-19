extends Control

signal construct_pressed()
signal stop_pressed()
signal leave_pressed()
signal selected_changed(construct)
signal add_queue()

var button_list = []


func _ready():
	add_all_buttons(self)
	$BoxContainer/Refinery/VBoxContainer/HBoxContainer/Scrap_Cost.set_text(str(TowerStuff.get_building_cost("Refinery")))


func add_all_buttons(node):
	for i in node.get_children():
		if i is BaseButton:
			button_list.append(i)
		if i.get_child_count() > 0:
			add_all_buttons(i)


func open():
	set_visible(true)
	for child in button_list:
		if child is BaseButton:
			child.call_deferred("set_disabled", false)


func close():
	set_visible(false)
	for child in button_list:
		if child is BaseButton:
			child.call_deferred("set_disabled", true)


func queue_pressed():
	emit_signal("add_queue")


func change_selected_construct(construct):
	emit_signal("selected_changed", construct)


func _leave():
	emit_signal("leave_pressed")


func _on_stop():
	emit_signal("stop_pressed")


func _on_construct():
	emit_signal("construct_pressed")
