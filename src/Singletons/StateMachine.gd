class_name StateMachine
extends Node

var state = null setget set_state
var previous_state = null
var states = {}
var state_names = {}

onready var parent = get_parent()

onready var label = get_parent().get_node("Label")

func _physics_process(delta):
	if state != null:
		_state_logic(delta)
		var transition = _get_transition(delta)
		if transition != null:
			set_state(transition)
#		displayState(state)

func _state_logic(_delta):
	pass

func _get_transition(_delta):
	return null

func _enter_state(_new_state, _old_state):
	pass

func _exit_state(_new_state, _old_state):
	pass

func set_state(new_state):
	previous_state = state
	state = new_state
	
	if previous_state != null:
		_exit_state(state, previous_state)

	if new_state != null:
		_enter_state(state, previous_state)


func add_state(state_name):
	states[state_name] = states.size()
	state_names[states.size()-1] = state_name
	
#	print(state_name)
#	print(states[state_name])

func displayState(state_name):
	label.set_text(state_names[state_name])
