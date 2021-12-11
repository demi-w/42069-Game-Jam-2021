extends StateMachine


func _ready():
	add_state("Idle")
	add_state("Walk")
	add_state("Fall")
	add_state("")
	call_deferred("set_state", states.Idle)

func _state_logic(delta):
	parent._apply_gravity(delta)

func _get_transition(delta):
	return null

func _enter_state(new_state, old_state):
	pass

func _exit_state(new_state, old_state):
	pass
