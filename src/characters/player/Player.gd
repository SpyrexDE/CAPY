extends CharacterBody2D

#############
# Variables #
#############

# Constants
@export var TARGET_FPS := 60
@export var ACCELERATION := 50
@export var MAX_SPEED := 400
@export var FRICTION := 15
@export var AIR_RESISTANCE := 0.1
@export var GRAVITY := 20
@export var JUMP_FORCE := 500
@export var PUSH := 100
@export var FORGIVE_TIME := 0.2
@export var MAX_AIR_JUMPS := 2
@export var AIR_DASH_SPEED := 1000
@export var AIR_DASH_OFFSET := 0.4
@export var AIR_FRICTION := 4

# Physics
@onready var aimed_scale = self.scale

# Input
var x_input := 0.0
var y_input := 0.0

# Logic
@onready var air_jumps := MAX_AIR_JUMPS
var can_jump := true
var jump_pressed := false
var should_jump := false
var jumptimer_active := false
var early_jumptimer_active := false
var air_dashing := false


# Child node references
@export
var cJumpTimer : Timer
@export
var cEarlyJumpTimer : Timer
@export
var cAnimationTree : AnimationTree
@export
var cCamera2D : Camera2D

#############
# Functions #
#############

func _ready() -> void:
	cAnimationTree.active = true

#Movement
func _physics_process(delta) -> void:
	handleCollsision()
	handleInput()
	handleMovement(delta)
	handleAnimation()

func handleInput() -> void:
	x_input = Input.get_vector("move_left", "move_right", "face_up", "face_down").x
	y_input = Input.get_action_strength("jump")

	jump_pressed = Input.is_action_just_pressed("jump")
	should_jump = Input.is_action_pressed("jump")

	if Input.is_action_just_pressed("attack"):
		#attack anims
		pass

func handleCollsision() -> void:
	checkPush()
	
	if is_on_floor():
		can_jump = true
		air_jumps = MAX_AIR_JUMPS
	elif !jumptimer_active:
		jumptimer_active = true
		cJumpTimer.start(FORGIVE_TIME)

func handleMovement(delta: float) -> void:
	# X-Acceleration
	velocity.x += x_input * ACCELERATION * delta * TARGET_FPS
	if air_dashing:
		velocity.x = lerp(velocity.x, 0, AIR_FRICTION * delta)
	else:
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	# Gravity
	velocity.y += GRAVITY * delta * TARGET_FPS
	
	# X-Friction
	if is_on_floor():
		# floor
		air_dashing = false
		if !is_moving() && is_on_floor():
			velocity.x = lerp(velocity.x, 0, FRICTION * delta)
	else:
		# air
		if !is_moving():
			velocity.x = lerp(velocity.x, 0, AIR_RESISTANCE * delta)
	
	# Jumping
	if jump_pressed or early_jumptimer_active:
		if can_jump:
			velocity.y = -JUMP_FORCE
			can_jump = false
			# Animate squash
			var t = create_tween()
			t.set_parallel(false)
			t.tween_property($Sprite, "scale:y", 0.25, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
			t.tween_property($Sprite, "scale:y", 0.2, 0.3).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
			
		
		# Air jumping
		if !is_on_floor() and air_jumps > 0 and not early_jumptimer_active:
			velocity.y = -JUMP_FORCE
			can_jump = false
			air_jumps -= 1
			# Animate squash
			var t = create_tween()
			t.set_parallel(false)
			t.tween_property($Sprite, "scale:y", 0.25, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
			t.tween_property($Sprite, "scale:y", 0.2, 0.3).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
			
		elif jump_pressed:
			early_jumptimer_active = true
			cEarlyJumpTimer.start(FORGIVE_TIME)
	
	# Make jump shorter when no longer pressed
	if !should_jump && !is_on_floor():
		velocity.y += GRAVITY * delta * TARGET_FPS
	
	# Air dash
	if !is_on_floor() && Input.is_action_just_pressed("roll") && !air_dashing:
		air_dashing = true
		var y_strength = Input.get_action_strength("face_down") - Input.get_action_strength("face_up")
		velocity = Vector2(x_input, y_strength - AIR_DASH_OFFSET * abs(x_input) + GRAVITY * 0.01) * AIR_DASH_SPEED
		
	# Apply velocity and rotation
	move_and_slide()
	
	if x_input != 0:
		flipH(true if x_input < 0 else false)

func handleAnimation() -> void:
	if is_moving():
		if is_on_floor():
			cAnimationTree.set("parameters/State/current", 2)
	else:
		if is_on_floor():
			cAnimationTree.set("parameters/State/current", 0)
	
	if !is_on_floor() && !is_on_wall():
		cAnimationTree.set("parameters/State/current", 1)

func flipH(flip: bool):
	# Workaround function for Godot issue #12335
	for child in get_children():
		if child.get("scale") != null:
			child.scale.x = (-1 if flip else 1) * abs(child.scale.x)

func checkPush() -> void:
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		if !collision.get_collider():
			return
		if collision.get_collider().is_in_group("bodies"):
			collision.get_collider().apply_central_impulse(-collision.normal * PUSH)


###########
# Getters #
###########

func is_moving() -> bool:
	if x_input != 0:
		return true
	else:
		return false

func is_jumping() -> bool:
	if y_input != 0:
		return true
	else:
		return false


###########
# Signals #
###########

func _on_JumpTimer_timeout() -> void:
	jumptimer_active = false
	can_jump = false


func _on_early_jump_timer_timeout() -> void:
	early_jumptimer_active = false
