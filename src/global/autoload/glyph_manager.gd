extends Node


func get_input_icon(action_string : String) -> Texture2D:
	var res_string := ""
	res_string += GlyphsMap.GLYPHS_DIR
	res_string += GlyphsMap.DEVICE_NAMES[InputHelper.device]
	res_string += "/"
	res_string += GlyphsMap.DEVICE_PREFIXES[InputHelper.device]
	res_string += get_action_icon_name(action_string)
	res_string += GlyphsMap.DEVICE_SUFFIXES[InputHelper.device]
	res_string += ".png"
	print(res_string)
	return load(res_string)

func get_action_icon_name(action_string) -> String:
	var base_string = InputHelper.get_action_key(action_string)
	for key in GlyphsMap.NAME_REPLACEMENTS.keys():
		if key in base_string:
			base_string = base_string.replace(key, GlyphsMap.NAME_REPLACEMENTS[key])
	return base_string
