extends Control

@onready
var main_menu := get_parent()

func _on_button_pressed() -> void:
	main_menu.fade_out()
	Game.load_savegame()
	print("changed")
	await Game.save_game_loaded	# never gets fired, idk how to fix this
	print("changed")
	var ll = LevelLoader.new()
	ll.start_load(Game.save_game.current_level)
	print("changed")
	await ll.load_done
	ll.change_scene()
	print("changed")
