extends StateMachine

func _ready():
	add_state("Idle")
	add_state("Flying")
	call_deferred("set_state", states.Idle)

func _state_logic(delta):
	if state == states.Idle:
		parent.rotation = (parent.get_parent().launchDir.get_position() - parent.get_position()).angle() + PI / 2
	elif state == states.Flying:
		parent.global_rotation = parent.linear_velocity.angle() + PI / 2

#parent.currentTower.rotation = (parent.get_global_mouse_position()-parent.towerSpawn.get_global_position()).angle() + PI/2

func _get_transition(delta):
	match state:
		states.Idle:
			if parent.get_linear_velocity() > Vector2(0,0):
				return states.Flying
		states.Flying:
			pass

func _enter_state(new_state, old_state):
	pass

func _exit_state(new_state, old_state):
	pass
