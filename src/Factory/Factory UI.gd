extends Control

signal construct_pressed()
signal stop_pressed()
signal leave_pressed()

var button_list = []

func _ready():
	add_all_buttons(self)
	print(button_list)


func add_all_buttons(node):
	for i in node.get_children():
		if i is Button:
			button_list.append(i)
		if i.get_child_count() > 0:
			add_all_buttons(i)
		else:
			pass


func open():
	set_visible(true)
	for child in button_list:
		if child is Button:
			child.call_deferred("set_disabled", false)


func close():
	set_visible(false)
	for child in button_list:
		if child is Button:
			child.call_deferred("set_disabled", true)
