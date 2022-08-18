extends Node

signal global_focus_changed(control: Control)

var last_focused_element : Control
var focused_element : Control


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:	# Mouse input not working?!?!?!??!?!?!?!?!?!
		
		# Simulate Keyboard input to set device to Keyboard & Mouse
		var a = InputEventKey.new()
		a.pressed = true
		Input.parse_input_event(a)
		
		# Remove any focus
		if focused_element != null:
			focused_element.release_focus()
		
	if event is InputEventJoypadButton or event is InputEventJoypadMotion or event is InputEventKey:
		if last_focused_element != null:
			last_focused_element.grab_focus()
	if Input.is_action_just_pressed("roll"):
		InputHelper.device = InputHelper.DEVICE_XBOX_CONTROLLER
		InputHelper.emit_signal("device_changed", null, null)

func _on_focus_changed(control : Control) -> void:
	emit_signal("global_focus_changed", control)
	if control != null:
		last_focused_element = control
	focused_element = control

# See SceneWrapper line 13
func _on_scene_added() -> void:
	for viewport in Game.scene_wrapper.get_viewports():
		if not viewport.is_connected("gui_focus_changed", _on_focus_changed):
			viewport.connect("gui_focus_changed", _on_focus_changed)
