extends StateMachine


func _ready():
	add_state("Idle")
	add_state("Walk")
	add_state("Jump")
	add_state("Fall")
	add_state("Run")
	call_deferred("set_state", states.Idle)

func _input(event):
	if [states.Idle, states.Walk, states.Run].has(state):
		if Input.is_action_pressed("jump"):
			parent.apply_central_impulse(parent.get_position().normalized() * 100)
		elif Input.is_action_pressed("run"):
			parent.maxSpeed = 200
		if Input.is_action_just_released("run"):
			parent.maxSpeed = 100

func _process(delta):
	parent.lastPosition = parent.get_position()

func _state_logic(delta):
	
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
			print("Idle")
		states.Walk:
			print("Walk")
		states.Jump:
			print("Jump")
		states.Fall:
			print("Fall")
		states.Run:
			print("Run")

func _exit_state(new_state, old_state):
	print("____")
	match old_state:
		states.Idle:
			print("Idle")
		states.Walk:
			print("Walk")
		states.Jump:
			print("Jump")
		states.Fall:
			print("Fall")
		states.Run:
			print("Run")
