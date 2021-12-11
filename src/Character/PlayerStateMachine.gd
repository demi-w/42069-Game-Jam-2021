extends StateMachine


func _ready():
	add_state("Idle")
	add_state("Walk")
	add_state("Jump")
	add_state("Fall")
	add_state("Run")
	call_deferred("set_state", states.Idle)

func _state_logic(delta):
	parent._update_rotation()
	parent._update_movDir()
	parent._handle_movement()
	print(parent.get_linear_velocity().project(parent.get_position().normalized()).length())

func _get_transition(delta):
	match state:
		states.Idle:
#			if !parent.is_grouded:
			pass
		states.Walk:
			pass
		states.Jump:
			pass
		states.Fall:
			pass
		states.Run:
			pass

func _enter_state(new_state, old_state):
	pass

func _exit_state(new_state, old_state):
	pass
