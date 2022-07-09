extends Node
class_name LevelSwitcher

@onready
var level_loader = LevelLoader.new()

@export
var scene_path : String

var loaded := false
var changing := false

func _ready() -> void:
	# Add level_loader as child so _process gets called
	add_child(level_loader)
	level_loader.start_load(scene_path)
	
	level_loader.load_done.connect(func(): loaded=true)
	level_loader.progress_changed.connect(func(progress): print(progress))

func change_scene() -> void:
	if not loaded or changing:
		printerr("too early")
		return
	changing = true
	level_loader.change_scene()
