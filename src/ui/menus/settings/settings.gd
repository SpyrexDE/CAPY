extends Control

const PAGES = ["res://src/ui/menus/settings/pages/general.tscn"]

@export
var tab_container : TabContainer

func _ready() -> void:
	for page in PAGES:
		var p : Control = load(page).instantiate()
		tab_container.add_child(p)
