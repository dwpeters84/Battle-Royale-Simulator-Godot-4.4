extends Button
signal area_passer(area)
signal map_updater(area_info)
var new_area_scene = preload("uid://xseu36qbixsb")

func _on_pressed() -> void:
	var new_area = new_area_scene.instantiate()
	%AreaContainer.add_child(new_area)
	new_area.changebg.load_bg.connect(change_bg)
	emit_signal("area_passer", new_area)
	new_area.update_map.connect(update_map)
	
func update_map(area_info):
	emit_signal("map_updater", area_info)

func change_bg():
	%BGLoader.popup()
