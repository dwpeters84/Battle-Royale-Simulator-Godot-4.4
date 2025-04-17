extends Button

var relationship_scene = preload("uid://2ek1oh0xlqex")

func _on_pressed() -> void:
	var new_relationship = relationship_scene.instantiate()
	%RelationshipContainer.add_child(new_relationship)
