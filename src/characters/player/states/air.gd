extends State


func unhandled_input(event: InputEvent) -> void:
	var move: = get_parent()
	move.unhandled_input(event)


func physics_process(delta: float) -> void:
	var move: = get_parent()
	move.physics_process(delta)

	# Landing
	if owner.is_on_floor():
		var target_state: = "Move/Idle" if move.get_move_direction().x == 0 else "Move/Run"
		_state_machine.transition_to(target_state)


func enter(msg: Dictionary = {}) -> void:
	var move: = get_parent()
	move.enter(msg)
	print(msg)
	move.acceleration.x = get_parent().JUMP_FORCE
	if "velocity" in msg:
		move.velocity = msg.velocity 
		move.max_speed.x = max(abs(msg.velocity.x), move.max_speed.x)
	if "impulse" in msg:
		move.velocity += calculate_jump_velocity(msg.impulse)


func exit() -> void:
	var move: = get_parent()
	move.acceleration = move.ACCELERATION
	move.exit()


func calculate_jump_velocity(impulse: float = 0.0) -> Vector2:
	var move: State = get_parent()
	return move.calculate_velocity(
		move.velocity,
		move.max_speed,
		Vector2(0.0, impulse),
		move.friction,
		1.0,
		Vector2.UP,
		move.GRAVITY
	)
