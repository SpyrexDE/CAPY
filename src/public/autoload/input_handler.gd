extends Node

var last_focused_element : Control
var focused_element : Control

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if focused_element != null:
			focused_element.release_focus()
	if event is InputEventJoypadButton or event is InputEventJoypadMotion or event is InputEventKey:
		if last_focused_element != null:
			last_focused_element.grab_focus()
	
	

func _on_focus_changed(control : Control) -> void:
	if control != null:
		last_focused_element = control
	focused_element = control

# See SceneWrapper line 13
func _on_scene_added() -> void:
	for viewport in Game.scene_wrapper.get_viewports():
		if not viewport.is_connected("gui_focus_changed", _on_focus_changed):
			viewport.connect("gui_focus_changed", _on_focus_changed)
