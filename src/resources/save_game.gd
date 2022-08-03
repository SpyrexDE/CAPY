class_name SaveGame
extends Resource

signal player_score_changed

# Metadata
@export var datetime : String

# Game data
@export var player_pos : Vector2

@export var player_score : int:
	set(value):
		player_score = value
		emit_signal("player_score_changed")

@export var current_level : String
