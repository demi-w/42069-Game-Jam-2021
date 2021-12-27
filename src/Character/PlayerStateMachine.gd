extends StateMachine


func _ready():
	add_state("Manning")
	add_state("Idle")
	add_state("Walk")
	add_state("Jump")
	add_state("Fall")
	add_state("Run")
	add_state("Throw")
	call_deferred("set_state", states.Idle)

func _input(_event):
	if ![states.Manning].has(state):
		if [states.Idle, states.Walk, states.Run].has(state):
			if Input.is_action_just_pressed("jump"):
				parent.apply_central_impulse(parent.get_position().normalized() * 100)
				#print(parent.get_linear_velocity().project(parent.get_position()))
				#parent.linear_velocity += parent.get_position().normalized()*80
			elif Input.is_action_pressed("run"):
				parent.maxSpeed = 150
			if Input.is_action_just_released("run"):
				parent.maxSpeed = 100
			if Input.is_action_just_pressed("throw") && parent.held_item != null:
				if parent.held_item is Asteroid:
					parent.crush_item()
				else:
					set_state(states.Throw)
		elif state == states.Throw:
			if Input.is_action_just_pressed("throw"):
				parent._throw()
		if Input.is_action_pressed("interact") && parent.interaction_timer.is_stopped():
			if parent.held_item != null:
				if parent.interaction_list.size() > 0:
					if parent.interaction_list[-1] is Building && parent.held_item is Projectile:
						parent.store_item(parent.interaction_list[-1])
				else:
					parent.drop_item()
			elif parent.interaction_list.size() > 0:
				if parent.interaction_list[0] is Scrap || parent.interaction_list[0] is Projectile || parent.interaction_list[0] is Asteroid:
					parent.pickup_item(parent.interaction_list[0])
				elif parent.interaction_list[0] is Building:
					parent.enter_building(parent.interaction_list[0])
			parent.interaction_timer.start()
	else:
#		if Input.is_action_just_pressed("interact") && parent.interaction_timer.is_stopped():
#			parent.get_parent().exit_building()
#			parent.interaction_timer.start()
		pass

#	if Input.is_action_pressed("interact"):
#			if parent.held_item == null:
#				if parent.interaction_list.size() > 0:
#					parent.pickup_item(parent.interaction_list[0])
#			elif parent.held_item != null:
#				parent.drop_item()

func _process(_delta):
	parent.lastPosition = parent.get_position()

func _state_logic(_delta):
	if ![states.Manning, states.Throw].has(state):
		parent._update_rotation()
		parent._update_movDir()
		parent._handle_movement()
	elif state == states.Throw:
		parent._update_rotation()
		parent._update_movDir()
		parent._update_angleDir()
		parent._handle_throw()
	if !is_instance_valid(parent.held_item):
		parent.held_item = null
		parent.f_button.set_visible(false)

func _get_transition(_delta):
	match state:
		states.Idle:
			if !parent.is_grounded:
				if parent.get_vertical_direction() < 0:
					return states.Jump
				elif parent.get_vertical_direction() >= 0:
					return states.Fall
			elif parent.get_linear_velocity().project(parent.get_position().tangent()).length() >= 40:
				return states.Walk
		states.Walk:
			if !parent.is_grounded:
				if parent.get_vertical_direction() < 0:
					return states.Jump
				elif parent.get_vertical_direction() >= 0:
					return states.Fall
			elif parent.get_linear_velocity().tangent().length() < 40:
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
		states.Throw:
			if parent.held_item == null:
				return states.Idle


func _enter_state(new_state, _old_state):
	match new_state:
		states.Idle:
			parent.sprite.play("Idle")
		states.Walk:
			parent.get_node("Sounds/Walk").play()
			parent.sprite.play("Walk")
		states.Jump:
			var music = parent.get_node("Sounds/Jump1")
			music.play()
		states.Fall:
			pass
		states.Run:
			parent.get_node("Sounds/Walk").play()
		states.Throw:
			parent.sprite.play("Throw")
			parent.f_button.set_visible(false)
			parent.f_button2.set_visible(true)
			parent.set_mode(1)
			parent.get_node("Launch_Direction").visible = true
		states.Manning:
			parent.show_behind_parent = true
			parent.z_index = 0


func _exit_state(_new_state, old_state):
	match old_state:
		states.Idle:
			pass
		states.Walk:
			parent.get_node("Sounds/Walk").stop()
		states.Jump:
			pass
		states.Fall:
			pass
		states.Run:
			parent.get_node("Sounds/Walk").stop()
		states.Throw:
			parent.set_mode(0)
			parent.f_button2.set_visible(false)
			parent.get_node("Launch_Direction").visible = false
		states.Manning:
			parent.show_behind_parent = false
			parent.z_index = 1


func _on_scrap_entered(body):
	if parent.held_item != body:
		parent.interaction_list.push_front(body)
	if parent.held_item == null:
		parent.e_button.set_visible(true)
#	print(parent.interaction_list)


func _on_scrap_body_exited(body):
	if body != parent.held_item:
		if parent.interaction_list.find(body) != -1:
			parent.interaction_list.remove(parent.interaction_list.find(body))
		if parent.interaction_list.size() == 0:
			parent.e_button.visible = false
#	print(parent.interaction_list)


func _on_Interaction_Area_area_entered(area):
	area = area.get_parent()
	if area != parent.get_parent():
		parent.interaction_list.append(area)
		if parent.held_item == null:
			parent.e_button.set_visible(true)
#	print(parent.interaction_list)


func _on_Interaction_Area_area_exited(area):
	area = area.get_parent()
	if area != parent.get_parent():
		parent.interaction_list.remove(parent.interaction_list.find(area))
		if parent.interaction_list.size() == 0:
			parent.e_button.visible = false
#	print(parent.interaction_list)
