extends Button

var data = CastData.new()

func _on_pressed() -> void:
	for child in %CharacterContainer.get_children():
		data.saved_cast.append(child)
		
	ResourceSaver.save(data, "user://scene_data.tres")
	print("Cast saved.")
	
#func _on_save_location_dir_selected(dir: String) -> void:
	#ResourceSaver.save(data, "user://scene_data.tres")
	#pass # Replace with function body.
