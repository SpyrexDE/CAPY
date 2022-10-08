extends Node

const ascii_letters_and_digits = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

static func calc_outline_scale(size: Vector2, scale: float, absoulte := false) -> Vector2:
	var width = size.x
	var height = size.y
	
	if width > height:
		scale = scale * (width / height)
	
	var factor = Vector2(1 + height * scale / width, 1 + scale)
	return factor

static func list_files_in_directory(path) -> PackedStringArray:
		var files = PackedStringArray([])
		var dir = DirAccess.open(path)
		dir.list_dir_begin()
	
		while true:
			var file = dir.get_next()
			if file == "":
				break
			elif not file.begins_with("."):
				files.append(file)
	
		dir.list_dir_end()
	
		return files

static func gen_unique_string(length: int) -> String:
	var result = ""
	for i in range(length):
		result += ascii_letters_and_digits[randi() % ascii_letters_and_digits.length()]
	return result
