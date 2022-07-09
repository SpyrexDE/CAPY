extends Node

var scene_wrapper : Node

signal save_game_loaded

const SAVE_GAME_PATH = "user://save.tres"

var save_game : SaveGame

var first_level = "res://src/levels/level01/level01.tscn"

# Save game handling
func _init() -> void:
	load_savegame()

func load_savegame():
	var t = Thread.new()
	t.start(_load_savegame)

func _load_savegame():
	if File.file_exists(SAVE_GAME_PATH):
		save_game = ResourceLoader.load(SAVE_GAME_PATH)
	else:
		save_game = SaveGame.new()
	emit_signal("save_game_loaded")

func write_savegame():
	ResourceSaver.save(SAVE_GAME_PATH, save_game)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("save_game"):
		save_game.current_level = "res://src/levels/level01/level01.tscn"
		write_savegame()
