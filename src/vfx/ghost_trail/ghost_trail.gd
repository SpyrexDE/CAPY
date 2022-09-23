extends Sprite2D


func _ready() -> void:
	var t = create_tween()
	t.tween_property(self, "modulate", Color.TRANSPARENT, 0.2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	await t.finished
	queue_free()
