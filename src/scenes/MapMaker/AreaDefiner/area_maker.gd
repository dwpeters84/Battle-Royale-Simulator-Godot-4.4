extends PanelContainer
signal update_map(area_info)

@onready var changebg = %ChangeBgImage
@onready var bg = %BgPreview

var areaname: String
var bg_img: Resource
var area_links: Array 
var tags: Array
var items: Array

var currently_linking: bool
signal link_areas(link)

@onready var area_info = {
	"name": areaname,
	"bg": bg_img,
	"links": area_links,
	"tags": tags,
	"items": items,
	}

func _ready():
	
	areaname = "Unnamed Area " + Codewords.codewords.pick_random()
	%AreaNameInput.placeholder_text = areaname

	add_to_group("AreaBaseNode")
	var node = get_tree().get_first_node_in_group("NewAreaButton")
	
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
	send_map_update()

func _on_area_name_input_text_changed() -> void:
	areaname = %AreaNameInput.text
	name = %AreaNameInput.text
	send_map_update()

func _on_change_bg_image_background_passer(bg: Variant) -> void:
	bg_img = bg 
	send_map_update()
	
func _on_add_item_update_item(item: Variant) -> void:
	print("Items updated!")
	
	if item == null:
		items.clear()
	else:
		items.clear()
		for child in %ItemContainer.get_children():
				print("Child is ", child, "!")
				items.append(child.get_child(0).get_selected())
	send_map_update()
	
func _on_add_tag_update_tag(tag: Variant) -> void:
	print("Tags updated!")
	
	if tag == null:
		tags.clear()
	else:
		tags.clear()
		for child in %TagContainer.get_children():
			print("Child is ", child, "!")
			tags.append(child.get_child(0).get_selected())
	send_map_update()

func _on_link_section_linker() -> void:
	currently_linking = true
	emit_signal("link_areas", self)
	pass # Replace with function body.
	
func receive_link(other_area):
	if other_area.areaname in area_info["links"]:
		print("This area is already linked!")
	else:
		area_links.append(other_area.areaname)
		print("Linked to: ", other_area.areaname)
		var link_label = Label.new()
		%LinkContainer.add_child(link_label)
		link_label.text = str(other_area.areaname)
		send_map_update()


func send_map_update():
	area_info["name"] = areaname
	area_info["bg"] = bg_img
	area_info["links"] = area_links
	area_info["tags"] = tags
	area_info["items"] = items
	emit_signal("update_map", area_info)	
