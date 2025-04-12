extends HBoxContainer
@onready var r_options = %RelationshipOptions
var in_list: Array = []
var current_edited: Array = []

func resize_texture(texture: Texture2D, new_size: Vector2) -> Texture2D:
	var img := texture.get_image()
	img.resize(new_size.x, new_size.y, Image.INTERPOLATE_LANCZOS)
	var resized_texture = ImageTexture.create_from_image(img)
	return resized_texture

func _on_relationship_options_pressed() -> void:
	

	r_options.clear()
	in_list.clear()

	for char in Cast.current_cast:		
		if char in Cast.picked_relationship:
			continue
		var char_icon = char.texture_rect.texture
		var char_name = char.name_input.text
		var resized_icon = resize_texture(char.texture_rect.texture, Vector2(32, 32)) 
		r_options.add_icon_item(resized_icon, char_name)
		
		in_list.append(char)
	pass # Replace with function body.
	

func _on_delete_pressed() -> void:
	queue_free()
	pass # Replace with function body.


func _on_relationship_options_item_selected(index: int) -> void:
	if Cast.current_cast.get(index) in Cast.picked_relationship:
		Cast.picked_relationship.remove_at(index)
	else:
		print(index, " was selected.")
		Cast.picked_relationship.append(Cast.current_cast.get(index))
