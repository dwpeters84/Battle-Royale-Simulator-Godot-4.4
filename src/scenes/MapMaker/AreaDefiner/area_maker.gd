extends PanelContainer

@onready var changebg = %ChangeBgImage
@onready var bg = %BgPreview

var areaname: String
var bg_img: String
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
