extends Node

func get_input_icon(action_string : String) -> Texture2D:
	var res_string := ""
	res_string += GlyphsMap.GLYPHS_DIR
	res_string += GlyphsMap.DEVICE_NAMES[InputHelper.device]
	res_string += "/"
	res_string += GlyphsMap.DEVICE_PREFIXES[InputHelper.device]
	res_string += get_controller_button_name(action_string, InputHelper.device)
	res_string += GlyphsMap.DEVICE_SUFFIXES[InputHelper.device]
	res_string += ".png"
	print(res_string)
	return load(res_string)

func get_controller_button_name(action_string : String, device_string : String) -> String:
	var base_name = get_action_icon_name(action_string)
	if is_controller_device(device_string):
		# base_name e.g.: Joypad Button 0 (Bottom Action, Sony Cross, Xbox A, Nintendo B)
		var items = base_name.split(",")
		
		items.remove_at(0)
		var btn_dict := {}
		for item in items:
			item = item.replace(")", "")
			var entry = item.split(" ")
			btn_dict[entry[1]] = entry[2]
		
		# { "Sony": "Cross", ...}
		for key in btn_dict.keys():
			match key:
				"Sony":
					if device_string == InputHelper.DEVICE_PLAYSTATION_CONTROLLER:
						return btn_dict[key]
				"Xbox":
					if device_string == InputHelper.DEVICE_XBOX_CONTROLLER or device_string == InputHelper.DEVICE_GENERIC:
						return btn_dict[key]
				"Nintendo":
					if device_string == InputHelper.DEVICE_SWITCH_CONTROLLER:
						return btn_dict[key]
	return base_name

func is_controller_device(device_string : String) -> bool:
	if device_string in GlyphsMap.CONTROLLER_DEVICES:
		return true
	return false

func get_action_icon_name(action_string : String) -> String:
	var base_string = InputHelper.get_action_key(action_string)
	for key in GlyphsMap.NAME_REPLACEMENTS.keys():
		if key in base_string:
			base_string = base_string.replace(key, GlyphsMap.NAME_REPLACEMENTS[key])
	return base_string
