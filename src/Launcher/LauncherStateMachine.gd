extends StateMachine


func _ready():
	add_state("Idle")
	add_state("Aim")
	add_state("Predict")
	add_state("Launch")
	add_state("Fucking")
	call_deferred("set_state", states.Idle)


func _state_logic(delta):
	if parent.manned:
		if parent.current_projectile != null:
			if state != states.Predict:
				parent._handle_aim()


func _get_transition(delta):
	match state:
		states.Idle:
			if parent.current_projectile != null:
				return states.Aim
		states.Aim:
			if parent.current_projectile == null:
				return states.Idle
		states.Launch:
			if parent.current_projectile == null:
				return states.Idle


func _enter_state(new_state, old_state):
	match new_state:
		states.Idle: 
			parent.launch_pos_sprite.set_visible(false)
		states.Aim:
			parent.launch_pos_sprite.set_visible(true)
		states.Predict:
			parent.predict_path(8*(parent.launch_pos_sprite.get_global_position()-parent.projectile_spawn.get_global_position()))
		states.Launch:
			parent.fire(8*(parent.launch_pos_sprite.get_global_position()-parent.projectile_spawn.get_global_position()))


func _exit_state(new_state, old_state):
	match old_state:
		states.Aim:
			pass
		states.Predict:
			parent.end_predict()


func _on_predict_pressed(state):
	if parent.current_projectile != null:
		if state:
			print("pressed")
			set_state(states.Predict)
		else:
			set_state(states.Aim)


func _on_launch_pressed():
	set_state(states.Launch)


func _on_back_pressed():
	parent.exit_building()
	set_state(states.Aim)
