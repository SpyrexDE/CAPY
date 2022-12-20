extends PlayerState

func physics_update(delta:float)->void:
#	if player.is_on_floor():
#		state_machine.transition_to("Run")
#		return
	
	# X-Acceleration
	player.velocity.x += player.x_input * player.ACCELERATION * delta * player.TARGET_FPS
	if player.air_dashing:
		player.velocity.x = lerp(player.velocity.x, 0.0, player.AIR_FRICTION * delta)
	else:
		player.velocity.x = clamp(player.velocity.x, -player.MAX_SPEED, player.MAX_SPEED)
	
	# Gravity
	player.velocity.y += player.GRAVITY * delta * player.TARGET_FPS
	
	# X-Friction
	if player.is_on_floor():
		# floor
		player.air_dashing = false
		if !player.is_moving() && player.is_on_floor():
			player.velocity.x = lerp(player.velocity.x, 0.0, player.FRICTION * delta)
		
		# state_machine.transition_to("Run") TODO: FIX STATE MACHINE
	else:
		# air
		if !player.is_moving():
			player.velocity.x = lerp(player.velocity.x, 0.0, player.AIR_RESISTANCE * delta)
	
	# Remove Air Dashing
	if player.velocity.length() < player.AIR_DASH_SPEED / 2:
		player.air_dashing = false
	
	# Jumping
	if player.jump_pressed or player.early_jumptimer_active:
		if player.can_jump:
			player.velocity.y = -player.JUMP_FORCE
			player.can_jump = false
			# Animate squash
			player.jump()
			
		
		# Air jumping
		if !player.is_on_floor() and player.air_jumps > 0 and not player.early_jumptimer_active:
			player.velocity.y = -player.JUMP_FORCE
			player.can_jump = false
			player.air_jumps -= 1
			# Animate squash
			player.jump()
			
		elif player.jump_pressed:
			player.early_jumptimer_active = true
			player.cEarlyJumpTimer.start(player.FORGIVE_TIME)
	
	# Make jump shorter when no longer pressed
	if !player.should_jump && !player.is_on_floor():
		player.velocity.y += player.GRAVITY * delta * player.TARGET_FPS
	
	# Air dash
	if !player.is_on_floor() && Input.is_action_just_pressed("dash") && !player.air_dashing:
		player.air_dashing = true
		var y_strength = Input.get_action_strength("face_down") - Input.get_action_strength("face_up")
		player.velocity = Vector2(player.x_input, y_strength - player.AIR_DASH_OFFSET * abs(player.x_input) + player.GRAVITY * 0.01).normalized() * player.AIR_DASH_SPEED
		player.dash()
		
	# Apply velocity and rotation
	player.move_and_slide()
	
	if player.x_input != 0:
		player.flipH(true if player.x_input < 0 else false)
