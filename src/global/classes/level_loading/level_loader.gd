extends Node
class_name LevelLoader

signal progress_changed(progress: float)
signal load_done

var _load_scene_resource: PackedScene
var _scene_path: String
var _progress: Array[float]= []

var loaded = false

# Starts loading of the given scene 
func start_load(scene_path: String) -> void:
	if !self.is_inside_tree():
		printerr("LevelLoader has to be added to the tree to it can access _process()")
	
	_scene_path = scene_path
	var state = ResourceLoader.load_threaded_request(_scene_path)
	if state == OK:
		set_process(true)
	else:
		printerr("Level cant be loaded!")
		set_process(false)

func _process(_delta: float) -> void:
	var load_status = ResourceLoader.load_threaded_get_status(_scene_path, _progress)
	match load_status:
		0, 2: # THREAD_LOAD_INVALID_RESOURCE, THREAD_LOAD_FAILED
			printerr("Level cant be loaded: ", load_status)
			set_process(false)
			return
		1: # THREAD_LOAD_IN_PROGRESS
			emit_signal("progress_changed", _progress[0])
		3: # THREAD_LOAD_LOADED
			_load_scene_resource = ResourceLoader.load_threaded_get(_scene_path)
			loaded = true
			emit_signal("progress_changed", 100.00)
			emit_signal("load_done")
			set_process(false)

# If loaded, change to scene
func change_scene() -> void:
	if !loaded:
		printerr("Level not loaded yet: " + str(_progress[0]))
	Game.scene_wrapper.transition_to(get_resource().instantiate())
	

# @return Last loaded resource
func get_resource() -> Resource:
	assert(loaded)
	return _load_scene_resource
