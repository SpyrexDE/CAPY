extends CharacterBody2D

@export
var SPEED := 10


@export
var cHUD : Control

@export
var cPlayer : CharacterBody2D

@export
var cCamera : Camera2D

@export
var cCollisionShape : CollisionShape2D


func _ready() -> void:
	global_position = cPlayer.global_position

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		var tween = create_tween()
		tween.tween_property(cCamera, "zoom", cCamera.zoom + Vector2(0.2, 0.2), 0.4).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	elif Input.is_action_just_pressed("zoom_out"):
		if cCamera.zoom - Vector2(0.1, 0.1) > Vector2.ZERO:
			var tween = create_tween()
			tween.tween_property(cCamera, "zoom", cCamera.zoom - Vector2(0.2, 0.2), 0.4).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func _process(delta) -> void:
	cCollisionShape.shape.size = get_viewport().get_visible_rect().size # * (Vector2.ONE - cCamera.zoom)
	
	var dif = cPlayer.global_position - global_position
	
	if dif.length() < 1:
		velocity = Vector2.ZERO
	else:
		velocity = dif * SPEED
		
	
	move_and_slide()
	
func _physics_process(delta: float) -> void:
	load("res://src/postprocessing/materials/tileset/grass_material.tres").set('offset', cCamera.global_position)
