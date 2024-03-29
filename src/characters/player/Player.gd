class_name Player
extends CharacterBody2D

#############
# PreLoads #
#############
const GHOST_TRAIL = preload("res://src/vfx/ghost_trail/ghost_trail.tscn")

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

@export var DIE_VELOCITY := Vector2(100, -100)

# Physics
@onready var aimed_scale = self.scale

# Animation
enum ANIMATIONS {
	IDLE,
	JUMP_UP,
	JUMP_DOWN,
	WALK
}

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
@export var cJumpTimer : Timer
@export var cEarlyJumpTimer : Timer
@export var cAnimationTree : AnimationTree
@export var cPlayerCamera : CharacterBody2D
@export var cSprite : AnimatedSprite2D
@export var cCollisionShape : CollisionShape2D
@export var cAudioPlayers : Node
@export var cDebugLabel : Label
@export var cStateMachine : Node

func _ready() -> void:
	cAnimationTree.active = true

func _physics_process(_delta):
	handleCollission()
	handleInput()
	handleAnimation()

func handleInput() -> void:
	x_input = Input.get_vector("move_left", "move_right", "face_up", "face_down").x
	y_input = Input.get_action_strength("jump")

	jump_pressed = Input.is_action_just_pressed("jump")
	should_jump = Input.is_action_pressed("jump")

	if Input.is_action_just_pressed("attack"):
		#attack anims
		pass

func handleCollission() -> void:
	checkPush()
	if is_on_floor():
		can_jump = true
		air_jumps = MAX_AIR_JUMPS
	elif !jumptimer_active:
		jumptimer_active = true
		cJumpTimer.start(FORGIVE_TIME)

func handleAnimation() -> void:
	walk(false)
	if is_moving():
		if is_on_floor():
			walk(true)
			cAnimationTree.set("parameters/Transition/current", ANIMATIONS.WALK)
	else:
		if is_on_floor():
			cAnimationTree.set("parameters/Transition/current", ANIMATIONS.IDLE)
	
	if !is_on_floor() && !is_on_wall():
		if velocity.y < 0:
			cAnimationTree.set("parameters/Transition/current", ANIMATIONS.JUMP_UP)
		else:
			cAnimationTree.set("parameters/Transition/current", ANIMATIONS.JUMP_DOWN)
	
	if air_dashing:
			var gt = GHOST_TRAIL.instantiate()
			get_parent().add_child(gt)
			gt.global_position = global_position
			gt.scale = cSprite.scale
			gt.texture = $Sprite.frames.get_frame($Sprite.animation, $Sprite.get_frame())

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

func jump() -> void:
	#var t = create_tween()
	#t.set_parallel(false)
	#t.tween_property($Sprite, "scale:y", 0.25, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	#t.tween_property($Sprite, "scale:y", 0.2, 0.3).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	
	if not is_on_floor():
		$Sprite/AirJumpSmoke.restart()
		$Sprite/AirJumpSmoke.emitting = true

func dash() -> void:
	cAnimationTree.set("parameters/dash/active", true)

func walk(value : bool) -> void:
	if value:
		$Sprite/WalkParticles.emitting = true
	else:
		$Sprite/WalkParticles.emitting = false

func die() -> void:
	cStateMachine.transition_to("Die")
	

###########
# GETTERS #
###########

func is_moving()->bool:
	if x_input == 0:
		return false
	return true

func is_jumping()->bool:
	if y_input ==0:
		return false
	return true

###########
# Signals #
###########

func _on_JumpTimer_timeout() -> void:
	jumptimer_active = false
	can_jump = false


func _on_early_jump_timer_timeout() -> void:
	early_jumptimer_active = false


func _on_sprite_frame_changed() -> void:
	pass
