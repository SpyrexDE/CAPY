extends Node
class_name LevelSwitcher

@onready
var level_loader = LevelLoader.new()

@export
var scene : PackedScene

var loaded := false

func _ready() -> void:
	# Add level_loader as child so _process gets called
	add_child(level_loader)
	level_loader.start_load(scene.resource_path)
	
	level_loader.load_done.connect(func(): loaded=true)
	level_loader.progress_changed.connect(func(progress): print(progress))

func change_scene() -> void:
	if not loaded:
		print("too early")
		return
	level_loader.change_scene()
