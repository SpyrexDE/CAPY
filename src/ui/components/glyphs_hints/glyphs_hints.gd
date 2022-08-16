extends Control

const GLYPHS_HINT = preload("res://src/ui/components/glyphs_hints/glyphs_hint/glyphs_hint.tscn") 

@export
var bg : ColorRect

var bg_intensity : float
var bg_opacity : float
var bg_rgb : Color

@onready
var hint_height = GLYPHS_HINT.instantiate().size.y / 1.5

@onready
var bg_base_size : Vector2 = $VignetteBackground.size
@onready
var bg_base_position : Vector2 = $VignetteBackground.position

@onready
var container_base_size : Vector2 = $VBoxContainer.size
@onready
var container_base_position : Vector2 = $VBoxContainer.position + $VBoxContainer.size / 2

func _ready() -> void:
	bg_intensity = bg.intensity
	bg_opacity = bg.opacity
	bg_rgb = bg.rgb
	
	bg.rgb.a = 0.0
	modulate.a = 0.0
	visible = true

func show() -> void:
	var t = create_tween()
	
	t.set_parallel(true)
	
	t.tween_property(bg, "rgb:a", bg_rgb.a, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	t.tween_property(self, "modulate:a", 1.0, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func hide() -> void:
	var t = create_tween()
	
	t.set_parallel(true)
	
	t.tween_property(bg, "rgb:a", 0.0, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	t.tween_property(self, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func set_glyphes(data : Dictionary):
	clear()
	
	for key in data.keys():
		var i = GLYPHS_HINT.instantiate()
		$VBoxContainer.add_child(i)
		
		i.text = key
		i.icon = GlyphManager.get_input_icon(data[key])
	
	adjust_sizing()

func adjust_sizing() -> void:
	$VBoxContainer.size.y =  $VBoxContainer.get_child_count() * hint_height
	$VignetteBackground.size.y = bg_base_size.y + $VBoxContainer.get_child_count() * hint_height
	$VBoxContainer.position.y = container_base_position.y - $VBoxContainer.get_child_count() * hint_height
	$VignetteBackground.position.y = bg_base_position.y - $VBoxContainer.get_child_count() * hint_height
	

func clear() -> void:
	for child in $VBoxContainer.get_children():
		$VBoxContainer.remove_child(child)
