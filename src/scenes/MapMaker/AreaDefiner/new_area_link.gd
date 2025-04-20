extends Button

var area_link_scene = preload("uid://2wbapkkm8d5j")

func _on_pressed() -> void:
	
	var new_area_link = area_link_scene.instantiate()
	new_area_link.custom_minimum_size = Vector2(150,30)
	add_sibling(new_area_link)
	pass # Replace with function body.
