extends PanelContainer
signal update_map(area_info)

@onready var changebg = %ChangeBgImage
@onready var bg = %BgPreview

var areaname: String
var bg_img: Resource
var links: Array 
var tags: Array
var items: Array

@onready var area_info = {
	"name": areaname,
	"bg": bg_img,
	"links": links,
	"tags": tags,
	"items": items,
	}

func _on_area_name_input_text_changed() -> void:
	areaname = %AreaNameInput.text
	print(areaname)
	send_map_update()

func _on_change_bg_image_background_passer(bg: Variant) -> void:
	bg_img = bg 
	send_map_update()

func send_map_update():
	area_info["name"] = areaname
	area_info["bg"] = bg_img
	area_info["links"] = links
	area_info["tags"] = tags
	area_info["items"] = items
	emit_signal("update_map", area_info)

	
