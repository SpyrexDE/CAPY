extends Control

const PAGE = preload("res://src/ui/menus/settings/page.tscn")

@export
var tab_container : TabContainer

func _ready() -> void:
	# TODO: For category in settingsManager instantiate new page with settings controls
	#var page_name = ""
	#var p : Control = PAGE.new(page_name)
	#tab_container.add_child(p)
	pass

func get_focus() -> void:
	tab_container.get_children()[0].get_focus()
