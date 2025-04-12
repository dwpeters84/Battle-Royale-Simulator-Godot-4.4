extends Button


var data = ResourceLoader.load("user://scene_data.tres") as CastData

func _on_pressed() -> void:
	for char in data.saved_cast:
		%CharacterContainer.add_child(char)
	pass # Replace with function body.
