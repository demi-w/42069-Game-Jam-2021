extends StateMachine


func _ready():
	add_state("Idle")
	add_state("Aim")
	add_state("Predict")
	add_state("Launch")
	add_state("Fucking")
	call_deferred("set_state", states.Idle)

func _input(event):
	if parent.currentTower != null:
		if [states.Aim].has(state):
			if parent.cursorInZone:
				if Input.is_action_pressed("ui_select"):
					set_state(states.Predict)
#					parent.fire(8*(parent.launchDir.get_global_position()-parent.towerSpawn.get_global_position()))
					pass

func _state_logic(delta):
	if parent.currentTower != null:
		if parent.cursorInZone:
			if state != states.Predict:
				parent.aim_reticle()
#			parent.currentTower.rotation = (parent.get_global_mouse_position()-parent.towerSpawn.get_global_position()).angle() + PI/2

func _get_transition(delta):
	match state:
		states.Idle:
			if parent.currentTower != null:
				return states.Aim
		states.Aim:
			if parent.currentTower == null:
				return states.Idle
		states.Launch:
			if parent.currentTower == null:
				return states.Idle

func _enter_state(new_state, old_state):
	match new_state:
		states.Idle: 
			parent.launchDir.set_visible(false)
		states.Aim:
			parent.launchDir.set_visible(true)
		states.Predict:
			parent.predict_path(8*(parent.launchDir.get_global_position()-parent.towerSpawn.get_global_position()))
			parent.launch_button(true)
		states.Launch:
			parent.fire(8*(parent.launchDir.get_global_position()-parent.towerSpawn.get_global_position()))
			parent.launch_button(false)

func _exit_state(new_state, old_state):
	match old_state:
		states.Aim:
			parent.tween.stop(parent.launchDir)
		states.Predict:

			parent.end_predict()


func _on_Mouse_Area_mouse_entered():
	parent.cursorInZone = true


func _on_Mouse_Area_mouse_exited():
	parent.cursorInZone = false


func _on_Launch_Button_pressed():
	set_state(states.Launch)


func _on_Back_pressed():
	set_state(states.Aim)


func _on_Player_Detection_body_entered(_body):
	parent.build_menu(true)


func _on_Player_Detection_body_exited(_body):
	parent.build_menu(false)
