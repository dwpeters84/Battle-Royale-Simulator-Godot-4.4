extends Button
signal update_item(item)

func _on_pressed() -> void:
	var item_scene = preload("res://src/scenes/ItemEditor/ItemEditor.tscn").instantiate()
	await item_scene.pass_item.connect(add_item_to_area)
	%ItemContainer.add_child(item_scene)

func add_item_to_area(item):
	emit_signal("update_item", item)
