extends HBoxContainer
signal pass_item(item)

func _ready():
	for item in Items.items:
		var itemimg = Items.items[item]
		%ItemButton.add_icon_item(itemimg, item)
	emit_signal("pass_item", %ItemButton.get_selected())

func _on_delete_self_pressed() -> void:
	queue_free()


func _on_item_button_item_selected(index: int) -> void:
	emit_signal("pass_item", index)
