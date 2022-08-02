extends Node

static func calc_outline_scale(size: Vector2, scale: float, absoulte := false) -> Vector2:
	var width = size.x
	var height = size.y
	
	if width > height:
		scale = scale * (width / height)
	
	var factor = Vector2(1 + height * scale / width, 1 + scale)
	return factor
