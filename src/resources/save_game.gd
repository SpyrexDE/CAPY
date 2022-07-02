class_name SaveGame
extends Resource

signal player_score_changed

@export var player_pos : Vector2

@export var player_score : int:
	set(value):
		player_score = value
		emit_signal("player_score_changed")
