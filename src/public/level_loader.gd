extends Node

signal progress_changed(progress: float)
signal load_done

var _load_scene_resource: PackedScene
var _scene_path: String
var _progress: Array[float]= []

var loaded = false


# Starts loading of the given scene
func start_load(scene_path: String) -> void:
	_scene_path = scene_path
	var state =  ResourceLoader.load_threaded_request(_scene_path, "", true)
	if state == OK:
		set_process(true)

func _process(_delta: float) -> void:
	var load_status = ResourceLoader.load_threaded_get_status(_scene_path, _progress)
	match load_status:
		0, 2: # THREAD_LOAD_INVALID_RESOURCE, THREAD_LOAD_FAILED
			set_process(false)
			return
		1: # THREAD_LOAD_IN_PROGRESS
			_update_progress()
		3: # THREAD_LOAD_LOADED
			_load_scene_resource = ResourceLoader.load_threaded_get(_scene_path)
			emit_signal("progress_changed", 100.00)
			emit_signal("load_done")

# If loaded, change to scene
func change_scene() -> void:
	assert(loaded)
	assert(get_tree().change_scene_to(_load_scene_resource) == OK)

# @return Last loaded resource
func get_resource() -> Resource:
	assert(loaded)
	return _load_scene_resource

func _update_progress() -> void:
	emit_signal("progress_changed", _progress[0])