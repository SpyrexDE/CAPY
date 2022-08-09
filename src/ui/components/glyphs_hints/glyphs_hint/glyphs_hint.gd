@tool
extends Control

@export
var label : Label

@export
var texture_rect : TextureRect

@export
var text := "[LABEL NOT SET]":
	set(val):
		text = val
		label.text = val

@export
var icon : Texture2D = preload("res://src/icons/Others/Controller_Disconnected.png"):
	set(val):
		icon = val
		texture_rect.texture = val
