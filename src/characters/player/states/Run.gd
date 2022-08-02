extends PlayerState

func enter(_msg := {})->void:
	player.can_jump = true
	player.air_dashing = false
	player.air_jumps = player.MAX_AIR_JUMPS

func physics_update(delta:float)->void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	# X Acceleration
	player.velocity.x = player.x_input * player.ACCELERATION * delta * player.TARGET_FPS
	player.velocity.x = clamp(player.velocity.x, -player.MAX_SPEED, player.MAX_SPEED)
	
	player.velocity.y += player.GRAVITY * delta * player.TARGET_FPS
	
	# X Friction
	if !player.is_moving():
		player.velocity.x = lerp(player.velocity.x, 0, player.FRICTION * delta)
	
	player.move_and_slide()
	
	if player.x_input != 0:
		player.flipH(true if player.x_input < 0 else false)
	
	if Input.is_action_just_pressed("jump") and player.can_jump:
		state_machine.transition_to("Air", { do_jump=true })
	elif player.velocity.x == 0:
		state_machine.transition_to("Idle")
