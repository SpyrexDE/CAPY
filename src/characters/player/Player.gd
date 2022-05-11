extends KinematicBody2D

#############
# Variables #
#############

# Constants
export (int, 1, 120) var TARGET_FPS = 60
export (int, 10, 50) var ACCELERATION = 30
export (int, 50, 800) var MAX_SPEED = 400
export (int, 0, 30) var FRICTION = 15
export (int, 0, 5) var AIR_RESISTANCE = 1
export (int, 0, 100) var GRAVITY = 20
export (int, 0, 1000) var JUMP_FORCE = 500
export (int, 0, 200) var PUSH = 100

# Physics
var motion := Vector2.ZERO

# Input
var x_input : float = 0.0
var y_input : float = 0.0

# Logic
var air_jumps := 1
var can_jump := true
var should_jump := false

# Node References
onready var animationPlayer := $AnimationPlayer

#############
# Functions #
#############

func _ready() -> void:
	pass

#Movement
func _physics_process(delta) -> void:
	handleInput()
	handleCollsision()
	handleAnimation()


func handleInput() -> void:
	x_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	y_input = Input.get_action_strength("jump")

	if Input.is_action_just_pressed("attack"):
		#attack anim
		pass

func handleCollsision() -> void:
	checkPush()
	
	if is_on_floor():
		can_jump = true

func handleAnimation():
	if is_moving():
		if is_on_floor():
			pass
			# run
		motion.x += x_input * ACCELERATION * delta * TARGET_FPS
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		
		setRot(Utils.completeInt(x_input))
		
	elif is_on_floor():
		# idle anim
		pass
	
	motion.y += GRAVITY * delta * TARGET_FPS
	
	if !is_on_floor() && !is_on_wall():
		# jump anim
		
		if !Input.is_action_pressed("jump"):
			motion.y /= 2
	
	if is_on_floor() && can_jump:
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION * delta)
			
		if y_input != 0 || should_jump == true:
			motion.y = -JUMP_FORCE
			can_jump = false
	else:
		if y_input != 0 and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)
		
		if !is_on_floor() and air_jumps > 0:
			if x_input == 0:
				motion.x = lerp(motion.x, 0, FRICTION * delta)
			
			if y_input != 0 || should_jump == true:
				motion.y = -JUMP_FORCE
				can_jump = false
	
	motion = move_and_slide(motion, Vector2.UP, false, 4, PI/4, false)

func setRot(rot):
	$Tween.interpolate_property($Rotator, "scale", $Rotator.scale, Vector2(rot,1), 0.05, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
	
func checkPush():
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if !collision.collider:
			return
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * PUSH)


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


