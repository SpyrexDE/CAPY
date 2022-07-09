extends Control

@onready
var main_menu := get_parent()

@export
var button_root : Control


const savegame_button = preload("res://src/ui/menus/save_select/savegame_button/savegame_button.tscn")

func _ready() -> void:
	# TODO: Draw save games
	var ngb = savegame_button.instantiate() as Button
	ngb.text = "+ New Game"
	ngb.pressed.connect(_new_game_pressed)
	button_root.add_child(ngb)

func get_focus() -> void:
	InputHandler.last_focused_element = button_root.get_children()[0]

func _load_game_pressed() -> void:	# TODO connect with line 13
	main_menu.fade_out()
	Game.load_savegame()
	await Game.save_game_loaded	# never gets fired, idk how to fix this
	var ll = LevelLoader.new()
	add_child(ll)
	ll.start_load(Game.save_game.current_level)
	await ll.load_done
	await get_tree().create_timer(0.5).timeout
	ll.change_scene()

func _new_game_pressed() -> void:
	main_menu.fade_out()
	Game.save_game = SaveGame.new()
	var ll = LevelLoader.new()
	add_child(ll)
	ll.start_load(Game.first_level)
	await ll.load_done
	await get_tree().create_timer(0.5).timeout
	ll.change_scene()
