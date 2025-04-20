extends Button
signal update_tag(tag)

func _on_pressed() -> void:
	var tag_scene = preload("uid://cu5klpau7awvd").instantiate()
	await tag_scene.pass_tag.connect(add_tag_to_area)
	$"../AddedTags/TagContainer".add_child(tag_scene)

func add_tag_to_area(tag):
	emit_signal("update_tag", tag)

	
