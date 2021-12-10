extends StateMachine


func _ready():
	add_state("Idle")
	add_state("Aim")
	add_state("Predict")
	add_state("Fucking")
	call_deferred("set_state", states.Idle)

func _input(event):
	if parent.currentTower != null:
		if [states.Aim].has(state):
			if parent.cursorInZone:
				if Input.is_action_pressed("ui_select"):
					pass
#					parent.fire(8*(parent.get_global_mouse_position()-parent.towerSpawn.get_global_position()))

func _state_logic(delta):
	if parent.currentTower != null:
		if parent.cursorInZone:
			parent.currentTower.follow_cursor(true)
			parent.aim_reticle()
			parent.currentTower.rotation = (parent.get_global_mouse_position()-parent.towerSpawn.get_global_position()).angle() + PI/2
		else:
			parent.currentTower.follow_cursor(false)

func _get_transition(delta):
	match state:
		states.Idle:
			if parent.currentTower != null:
				return states.Aim

func _enter_state(new_state, old_state):
	match state:
		states.Aim:
			parent.launchDir.set_visible(true)

func _exit_state(new_state, old_state):
	pass


func _on_Mouse_Area_mouse_entered():
	parent.cursorInZone = true


func _on_Mouse_Area_mouse_exited():
	parent.cursorInZone = false
