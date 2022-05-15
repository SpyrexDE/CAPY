extends CharacterBody2D

#############
# Variables #
#############

# Constants
@export var TARGET_FPS := 60
@export var ACCELERATION := 50
@export var MAX_SPEED := 400
@export var FRICTION := 15
@export var AIR_RESISTANCE := 1
@export var GRAVITY := 20
@export var JUMP_FORCE := 500
@export var PUSH := 100
@export var FORGIVE_TIME := 0.2
@export var MAX_AIR_JUMPS := 2

# Physics
@onready var aimed_scale = self.scale 

# Input
var x_input : float = 0.0
var y_input : float = 0.0

# Logic
@onready var air_jumps := MAX_AIR_JUMPS
var can_jump := true
var jump_pressed := false
var should_jump := false
var jumptimer_active := false

# Child node references
@onready var cJumpTimer = $JumpTimer
@onready var cAnimationTree = $AnimationTree
@onready var cCamera2D = $Camera2D

#############
# Functions #
#############

func _ready() -> void:
	pass

#Movement
func _physics_process(delta) -> void:
	handleCollsision()
	handleInput()
	handleMovement(delta)
	handleAnimation()
	

func handleInput() -> void:
	x_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
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
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	# Gravity
	velocity.y += GRAVITY * delta * TARGET_FPS
	
	# X-Friction
	if is_on_floor():
		# floor
		if !is_moving() && is_on_floor():
			velocity.x = lerp(velocity.x, 0, FRICTION * delta)
	else:
		# air
		if !is_moving() && !is_on_floor():
			velocity.x = lerp(velocity.x, 0, AIR_RESISTANCE * delta)
	
	# Jumping
	if jump_pressed:
		if can_jump:
			velocity.y = -JUMP_FORCE
			can_jump = false
		
		# Air jumping
		if !is_on_floor() and air_jumps > 0:
				velocity.y = -JUMP_FORCE
				can_jump = false
				air_jumps -= 1
	
	# Make jump shorter when no longer pressed
	if !should_jump && !is_on_floor():
		velocity.y += GRAVITY * delta * TARGET_FPS

	# Apply velocity and rotation
	move_and_slide()
	
	if x_input != 0:
		flipH(true if x_input < 0 else false)

func handleAnimation() -> void:
	if is_moving():
		if is_on_floor():
			pass
			# run
	else:
		if is_on_floor():
			cAnimationTree.set("parameters/State/current", 0)
	
	if !is_on_floor() && !is_on_wall():
		cAnimationTree.set("parameters/State/current", 1)

func flipH(flip:bool):
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
