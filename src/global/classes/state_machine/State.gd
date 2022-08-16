class_name State
extends Node

#Reference to the state machine. Will be set by the state machine object.
var state_machine = null

#################
# Virtual Funcs #
#################

#Receives events from the '_unhandled_input()' callback.
func handle_input(_event : InputEvent)->void:
	pass

#Same as '_process()' callback.
func update(_delta: float)->void:
	pass

#Same as '_phyisics_process()' callback.
func physics_update(_delta : float)->void:
	pass

#Called by state machine when switching the active state.
#'_msg' is a dict with arbitrary data for states to use when initializing.
func enter(_msg := {})->void:
	pass

#Called by the state machine before changing the active state.
#This is used for cleanup.
func exit()->void:
	pass
