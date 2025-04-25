extends Button
signal area_passer(area)
signal map_updater(area_info)
signal link_passer(link)
var new_area_scene = preload("uid://xseu36qbixsb")

var area_to_link_1 = null
var area_to_link_2 = null

func _on_pressed() -> void:
	var new_area = new_area_scene.instantiate()
	%AreaContainer.add_child(new_area)
	new_area.changebg.load_bg.connect(change_bg)
	emit_signal("area_passer", new_area)
	new_area.update_map.connect(update_map)
	new_area.link_areas.connect(link_areas)
	
func update_map(area_info):
	emit_signal("map_updater", area_info)

func change_bg():
	%BGLoader.popup()


func link_areas(area):
	if not area_to_link_1:
		area_to_link_1 = area
		print("Grabbed first area:", area_to_link_1)
	elif not area_to_link_2:
		area_to_link_2 = area
		
		print("Grabbed second area:", area_to_link_2)
		print("Linking...")

		# Send the link to both areas
		area_to_link_1.receive_link(area_to_link_2)
		area_to_link_2.receive_link(area_to_link_1)

		# Reset for next link
		area_to_link_1 = null
		area_to_link_2 = null
