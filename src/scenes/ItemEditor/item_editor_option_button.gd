extends HBoxContainer
signal pass_item(item)

func _ready():
	for item in Items.items:
		var itemimg = Items.items[item]
		%ItemButton.add_icon_item(itemimg, item)
	pass


func _on_delete_self_pressed() -> void:
	queue_free()
	pass # Replace with function body.

func _on_item_button_item_selected(index: int) -> void:
	emit_signal("pass_item", index)
	pass # Replace with function body.
