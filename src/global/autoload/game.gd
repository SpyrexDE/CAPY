extends Node

var scene_wrapper : Node

const first_level = "res://src/levels/level01/level01.tscn"

const SAVE_GAME_DIR = "user://savegames/"
var save_game : SaveGame
var save_game_file_name : String

# Save game handling

func apply_savegame(_save_game : SaveGame, file_name : String) -> void:
	self.save_game = _save_game
	self.save_game_file_name = file_name

func write_savegame() -> void:
	# Prepare SaveGame resource
	save_game.datetime = Time.get_date_string_from_system()
	save_game.current_level = first_level
	
	ensure_savegame_dir()
	
	ResourceSaver.save(save_game, SAVE_GAME_DIR + save_game_file_name)

# Returns a dictionary with file_name as key and SaveGame res as value
func load_savegames() -> Dictionary:
	var savegames = {}
	
	ensure_savegame_dir()
	
	for file in list_savegame_files():
		savegames[file] = ResourceLoader.load(SAVE_GAME_DIR + file)
	return savegames

func list_savegame_files() -> PackedStringArray:
	return Utils.list_files_in_directory(SAVE_GAME_DIR)

func new_save_game() -> void:
	self.save_game = SaveGame.new()
	self.save_game_file_name = Utils.gen_unique_string(10) + ".tres"

func ensure_savegame_dir() -> void:
	var dir = Directory.new()
	if not dir.dir_exists(SAVE_GAME_DIR):
		dir.make_dir(SAVE_GAME_DIR)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("save_game"):
		write_savegame()
	if Input.is_action_just_pressed("ui_cancel"):
		scene_wrapper.transition_to(load("res://src/ui/menus/main/main_menu.tscn").instantiate())
