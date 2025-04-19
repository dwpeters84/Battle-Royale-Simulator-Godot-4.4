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

func _ready():
	# This is fucking insane. Delete this at some point LMFAO. Or come up with a better way of storing the colors at least LMFAO
	var colors = [
  Color.AQUA, Color.AQUAMARINE, Color.BLACK, Color.BLUE, Color.BROWN,
  Color.CADET_BLUE, Color.CHARTREUSE, Color.CRIMSON, Color.CYAN,
  Color.DARK_BLUE, Color.DARK_CYAN, Color.DARK_GREEN, Color.DARK_ORANGE,
  Color.DARK_RED, Color.DARK_VIOLET, Color.DEEP_PINK, Color.DEEP_SKY_BLUE,
  Color.DODGER_BLUE, Color.FIREBRICK, Color.FUCHSIA, Color.GOLD,
  Color.GREEN, Color.HOT_PINK, Color.INDIAN_RED, Color.INDIGO,
  Color.LIME, Color.MAGENTA, Color.MAROON, Color.MEDIUM_BLUE,
  Color.MEDIUM_VIOLET_RED, Color.MIDNIGHT_BLUE, Color.NAVY_BLUE,
  Color.OLIVE, Color.ORANGE, Color.ORANGE_RED, Color.ORCHID,
  Color.PINK, Color.PLUM, Color.PURPLE, Color.RED, Color.ROSY_BROWN,
  Color.ROYAL_BLUE, Color.SALMON, Color.SIENNA, Color.SKY_BLUE,
  Color.SLATE_BLUE, Color.SPRING_GREEN, Color.STEEL_BLUE, Color.TEAL,
  Color.TOMATO, Color.TURQUOISE, Color.VIOLET, Color.YELLOW, Color.YELLOW_GREEN
]

	var random_color = colors.pick_random()
	%AreaBG.color = random_color
	
	pass

func _on_area_name_input_text_changed() -> void:
	areaname = %AreaNameInput.text
	send_map_update()

func _on_change_bg_image_background_passer(bg: Variant) -> void:
	bg_img = bg 
	send_map_update()
	
func _on_add_item_update_item(item: Variant) -> void:
	items.clear()
	for child in %ItemContainer.get_children():
		items.append(child.get_child(0).get_selected())
	
	
func send_map_update():
	area_info["name"] = areaname
	area_info["bg"] = bg_img
	area_info["links"] = links
	area_info["tags"] = tags
	area_info["items"] = items
	emit_signal("update_map", area_info)
