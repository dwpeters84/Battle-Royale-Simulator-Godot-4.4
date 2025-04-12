extends Button

var relationship_scene = preload("res://RelationshipEditor.tscn")

func _on_pressed() -> void:
	var new_relationship = relationship_scene.instantiate()
	add_sibling(new_relationship)
	pass # Replace with function body.
