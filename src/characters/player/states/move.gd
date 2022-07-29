extends State


@export var ACCELERATION := Vector2(100000, 3000.0)
@export var MAX_SPEED := Vector2(500.0, 1500.0)
@export var FRICTION := 15
@export var AIR_RESISTANCE := 0.1
@export var GRAVITY := 0.8
@export var JUMP_FORCE := 900.0
@export var PUSH := 100
@export var FORGIVE_TIME := 0.2
@export var MAX_AIR_JUMPS := 2
@export var AIR_DASH_SPEED := 1000
@export var AIR_DASH_OFFSET := 0.4
@export var AIR_FRICTION := 4

var acceleration: = ACCELERATION
var max_speed: = MAX_SPEED
var gravity: = GRAVITY
var friction: = FRICTION
var velocity: = Vector2.ZERO


#func _on_Hook_hooked_onto_target(target_global_position: Vector2) -> void:
#	var to_target: Vector2 = target_global_position - owner.global_position
#	if owner.is_on_floor() and to_target.y > 0.0:
#		return
#
#	_state_machine.transition_to("Hook", {target_global_position = target_global_position, velocity = velocity})


func unhandled_input(event: InputEvent) -> void:
	if owner.is_on_floor() and event.is_action_pressed("jump"):
		_state_machine.transition_to("Move/Air", { impulse = JUMP_FORCE })


func physics_process(delta: float) -> void:
	velocity = calculate_velocity(velocity, max_speed, acceleration, friction, delta, get_move_direction(), gravity)
	owner.velocity = velocity
	owner.move_and_slide()
	Events.emit_signal("player_moved", owner)


func enter(msg: Dictionary = {}) -> void:
	pass#owner.hook.connect("hooked_onto_target", self, "_on_Hook_hooked_onto_target")


func exit() -> void:
	pass#owner.hook.disconnect("hooked_onto_target", self, "_on_Hook_hooked_onto_target")


static func calculate_velocity(
		old_velocity: Vector2,
		max_speed: Vector2,
		acceleration: Vector2,
		friction: float,
		delta: float,
		move_direction: Vector2,
		gravity: float
	) -> Vector2:
	var new_velocity: = old_velocity

	new_velocity.x += move_direction.x * acceleration.x * delta
	new_velocity.y += gravity * acceleration.y * delta
	
	new_velocity.x = lerp(new_velocity.x, 0, friction)
	return new_velocity


static func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("face_up") - Input.get_action_strength("face_down"),
	)
