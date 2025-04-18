extends PanelContainer

@onready var changebg = %ChangeBgImage
@onready var bg = %BgPreview

var areaname: String
var bg_img
var links: Array 
var tags: Array
var items: Array

@onready var area_info = {
	"name": areaname,
	"bg": bg_img,
	"links": [links],
	"tags": [tags],
	"items": [items],
	}

func _on_area_name_input_text_changed() -> void:
	areaname = %AreaNameInput.text
	print(areaname)
	pass # Replace with function body.

func _on_change_bg_image_background_passer(bg: Variant) -> void:
	bg_img = bg
	pass # Replace with function body.
