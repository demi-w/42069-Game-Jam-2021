extends StateMachine


func _ready():
	add_state("Manning")
	add_state("Idle")
	add_state("Walk")
	add_state("Jump")
	add_state("Fall")
	add_state("Run")
	call_deferred("set_state", states.Idle)

func _input(_event):
	if [states.Idle, states.Walk, states.Run].has(state):
		if Input.is_action_pressed("jump"):
			#parent.apply_central_impulse(parent.get_position().normalized() * 100)
			#print(parent.get_linear_velocity().project(parent.get_position()))
			parent.linear_velocity += parent.get_position().normalized()*80
		elif Input.is_action_pressed("run"):
			parent.maxSpeed = 150
		if Input.is_action_just_released("run"):
			parent.maxSpeed = 100
			
	if Input.is_action_pressed("interact") && parent.interaction_timer.is_stopped():
		if [states.Manning].has(state):
			parent.leave_building()
			set_state(states.Idle)
		elif parent.held_item != null:
			print("yeahoh")
			print(parent.interaction_list)
			if parent.interaction_list.size() > 0:
				if parent.interaction_list[-1] is Area2D && parent.held_item.get_collision_layer() == 8:
					parent.store_item(parent.interaction_list[-1])
			else:
				parent.drop_item()
		elif parent.interaction_list.size() > 0:
			if parent.interaction_list[0] is Scrap || parent.interaction_list[0].get_collision_layer() == 8:
				parent.pickup_item(parent.interaction_list[0])
			elif parent.interaction_list[0].get_parent() is Launcher:
				parent.enter_building(parent.interaction_list[0])
				set_state(states.Manning)
		parent.interaction_timer.start()
	
#	if Input.is_action_pressed("interact"):
#			if parent.held_item == null:
#				if parent.interaction_list.size() > 0:
#					parent.pickup_item(parent.interaction_list[0])
#			elif parent.held_item != null:
#				parent.drop_item()

func _process(_delta):
	parent.lastPosition = parent.get_position()

func _state_logic(_delta):
	if ![states.Manning].has(state):
		parent._update_rotation()
		parent._update_movDir()
		parent._handle_movement()

func _get_transition(delta):
	match state:
		states.Idle:
			if !parent.is_grounded:
				if parent.get_vertical_direction() < 0:
					return states.Jump
				elif parent.get_vertical_direction() >= 0:
					return states.Fall
			elif parent.get_linear_velocity().project(parent.get_position().tangent()).length() >= 5:
				return states.Walk
		states.Walk:
			if !parent.is_grounded:
				if parent.get_vertical_direction() < 0:
					return states.Jump
				elif parent.get_vertical_direction() >= 0:
					return states.Fall
			elif parent.get_linear_velocity().tangent().length() < 5:
				return states.Idle
			elif parent.get_linear_velocity().tangent().length() > 120:
				return states.Run
		states.Jump:
			if parent.is_grounded:
				return states.Idle
			elif parent.get_vertical_direction() >= 0:
				return states.Fall
		states.Fall:
			if parent.is_grounded:
				return states.Idle
			elif parent.get_vertical_direction() < 0:
				return states.Jump
		states.Run:
			if !parent.is_grounded:
				if parent.get_vertical_direction() < 0:
					return states.Jump
				elif parent.get_vertical_direction() >= 0:
					return states.Fall
			elif parent.get_linear_velocity().tangent().length() < 5:
				return states.Idle
			elif parent.get_linear_velocity().tangent().length() <= 120:
				return states.Walk

func _enter_state(new_state, old_state):
	match new_state:
		states.Idle:
			pass
		states.Walk:
			pass
		states.Jump:
			pass
		states.Fall:
			pass
		states.Run:
			pass

func _exit_state(new_state, old_state):
	match old_state:
		states.Idle:
			pass
		states.Walk:
			pass
		states.Jump:
			pass
		states.Fall:
			pass
		states.Run:
			pass


func _on_scrap_entered(body):
	if parent.held_item != body:
		parent.interaction_list.push_front(body)
	parent.get_node("Control/Button").set_visible(true)
#	print(parent.interaction_list)


func _on_scrap_body_exited(body):
	if parent.interaction_list.size() == 0:
		parent.get_node("Control/Button").visible = false
	parent.interaction_list.remove(parent.interaction_list.find(body))
#	print(parent.interaction_list)


func _on_Interaction_Area_area_entered(area):
	parent.interaction_list.append(area)
	parent.get_node("Control/Button").set_visible(true)
#	print(parent.interaction_list)


func _on_Interaction_Area_area_exited(area):
	if parent.interaction_list.size() == 0:
		parent.get_node("Control/Button").visible = false
	parent.interaction_list.remove(parent.interaction_list.find(area))
#	print(parent.interaction_list)
