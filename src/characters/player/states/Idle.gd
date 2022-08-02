extends PlayerState

func enter(_msg := {})->void:
	player.air_dashing = false
	player.can_jump = true
	player.air_jumps = player.MAX_AIR_JUMPS

func update(_delta:float)->void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	if Input.is_action_just_pressed("jump") and player.can_jump == true:
		state_machine.transition_to("Air", {do_jump = true})
	elif player.x_input != 0:
		state_machine.transition_to("Run")
