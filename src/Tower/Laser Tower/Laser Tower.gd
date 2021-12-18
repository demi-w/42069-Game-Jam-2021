extends Tower

func fire():
	get_tree().remove_child(_target)
	print("pew!")
