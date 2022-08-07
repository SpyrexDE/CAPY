extends Node

signal scene_added

const STARTUP_SCENE = preload("res://src/ui/menus/main/main_menu.tscn")

var current : Node

func _ready() -> void:
	Game.scene_wrapper = self
	current = add_node(STARTUP_SCENE.instantiate())

func add_node(node : Node) -> Node:
	var vpc = SubViewportContainer.new()
	var vp = SubViewport.new()
	
	vp.transparent_bg = true
	
	vp.size = Vector2(ProjectSettings.get("display/window/size/viewport_width"), ProjectSettings.get("display/window/size/viewport_height"))	# Workaround to set size to fullscreen
	vp.handle_input_locally = false
	
	add_child(vpc)
	vpc.add_child(vp)
	vp.add_child(node)
	
	# Workaround for weird Godot 4.0-alpha behavior where viewports dont get drawn, remove in beta
	vpc.hide()
	vpc.show()
	
	# Workaround for signals not working
	InputHandler._on_scene_added()
	
	return vpc

func transition_to(node : Node) -> void:
	var new = add_node(node)
	
	var t = create_tween()
	t.set_parallel(true)
	
	t.tween_property(node, "modulate", Color.WHITE, 0.5).from(Color.TRANSPARENT).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_property(current, "modulate", Color.TRANSPARENT, 0.5).from(Color.WHITE).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	await t.finished
	current.queue_free()
	current = new

func get_viewports() -> Array:
	var viewports = []
	for child in get_children():
		if child is SubViewportContainer:
			for c in child.get_children():
				if c is SubViewport:
					viewports.append(c)
	return viewports
