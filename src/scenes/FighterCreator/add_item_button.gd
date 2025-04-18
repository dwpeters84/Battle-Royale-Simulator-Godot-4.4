extends Button

func _on_pressed() -> void:
	var option_button = preload("uid://bp5uttecs152g")
	var new_item_button = option_button.instantiate()
	%ItemContainer.add_child(new_item_button)
	pass # Replace with function body.
