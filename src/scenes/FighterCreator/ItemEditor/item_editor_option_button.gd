extends HBoxContainer

func _ready():
	for item in Items.items:
		var itemimg = Items.items[item]
		%ItemButton.add_icon_item(itemimg, item)
	pass


func _on_delete_self_pressed() -> void:
	queue_free()
	pass # Replace with function body.
