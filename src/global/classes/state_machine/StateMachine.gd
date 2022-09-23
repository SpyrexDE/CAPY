class_name StateMachine
extends Node

###########
# SIGNALS #
###########

#Emitted when transitioning to another state.
signal transitioned(state_name)

#############
# VARIABLES #
#############

#Path to the initial active state.
@export var initial_state := NodePath()

#The currently active state.
@onready var state: State = get_node(initial_state)


func _ready() -> void:
	await owner.ready
	for child in get_children():
		child.state_machine = self


#######################
# CALLBACK DELEGATION #
#######################

func _unhandled_input(event) -> void:
	state.handle_input(event)

func _process(delta) -> void:
	state.update(delta)

func _physics_process(delta) -> void:
	state.physics_update(delta)


#############
# FUNCTIONS #
#############

#Function calls current state's exit function, then transitions to the new state and calls its enter function
#It can take a '_msg' dict for arguments if your state requires one for its enter function.
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name):
		return
	
	state.exit()
	state=get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
