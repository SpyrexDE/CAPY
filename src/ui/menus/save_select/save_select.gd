extends Control

@onready
var main_menu := get_parent()

@export
var button_root : Control


const savegame_button = preload("res://src/ui/menus/save_select/savegame_button/savegame_button.tscn")

func _ready() -> void:
	var save_games = Game.load_savegames()
	for save_game_name in save_games.keys():
		var save_game = save_games[save_game_name]
		add_btn(save_game.datetime, _load_game_pressed, {"save_game": save_games[save_game_name], "save_name": save_game_name})
		
	add_btn("+ New Game", _new_game_pressed)

func add_btn(text : String, callback : Callable, params := {}) -> void:
	var btn = savegame_button.instantiate() as Button
	btn.text = text
	btn.pressed.connect(callback) if params.size() == 0 else btn.pressed_ref.connect(callback)
	button_root.add_child(btn)
	btn.params = params

func get_focus() -> void:
	InputHandler.last_focused_element = button_root.get_children()[0]

func _load_game_pressed(btn) -> void:
	var params = btn.params
	main_menu.fade_out()
	Game.apply_savegame(params["save_game"], params["save_name"])
	var ll = LevelLoader.new()
	add_child(ll)
	ll.start_load(Game.save_game.current_level)
	await ll.load_done
	await get_tree().create_timer(0.5).timeout
	ll.change_scene()

func _new_game_pressed() -> void:
	main_menu.fade_out()
	Game.new_save_game()
	var ll = LevelLoader.new()
	add_child(ll)
	ll.start_load(Game.first_level)
	await ll.load_done
	await get_tree().create_timer(0.5).timeout
	ll.change_scene()
