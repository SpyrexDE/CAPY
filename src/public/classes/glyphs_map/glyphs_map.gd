extends Resource
class_name GlyphsMap

const GLYPHS_DIR := "res://src/icons/"

const DEVICE_NAMES := {
	"keyboard": "Keyboard & Mouse/Dark",
	"xbox": "Xbox Series",
	"playstation": "PS5",
	"generic": "Xbox Series"
}

const DEVICE_PREFIXES := {
	"keyboard": "",
	"xbox": "XboxSeriesX_",
	"playstation": "PS5_",
	"generic": "XboxSeriesX_"
}

const DEVICE_SUFFIXES := {
	"keyboard": "_Key_Dark",
	"xbox": "",
	"playstation": "",
	"generic": ""
}

const NAME_REPLACEMENTS := {
	"Delete": "Del"
}
