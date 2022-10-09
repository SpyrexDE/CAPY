extends PlayerState

@onready
var body_wrapper = load("res://src/vfx/rigid_body_wrapper/rigid_body_wrapper.tscn").instantiate()

func enter(_msg := {}) -> void:
	player.get_parent().add_child(body_wrapper)
	player.get_parent().remove_child(player)
	body_wrapper.add_child(player)
	body_wrapper.apply_impulse(Vector2(player.velocity.x / 2, -700))
	player.cPlayerCamera.follow_player = false
	var t = create_tween()
	t.tween_property(player, "rotation", 5.0, 2).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	await t.finished
	# ReLoad savegame 
	var ll = LevelLoader.new()
	add_child(ll)
	ll.start_load(Game.save_game.current_level)
	await ll.load_done
	await get_tree().create_timer(0.5).timeout	# Buffer so you actually get to see the loading screen
	ll.change_scene()
