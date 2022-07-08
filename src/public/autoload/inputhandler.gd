extends Node

var last_focused_element : Control
var focused_element : Control

func _ready() -> void:
	get_viewport().connect("gui_focus_changed", _on_focus_changed)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if focused_element != null:
			focused_element.release_focus()
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if last_focused_element != null:
			last_focused_element.grab_focus()


func _on_focus_changed(control : Control) -> void:
	print(control)
	if control != null:
		last_focused_element = control
	focused_element = control
