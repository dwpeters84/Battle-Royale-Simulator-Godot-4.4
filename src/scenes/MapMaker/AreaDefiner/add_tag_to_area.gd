extends Button

@onready var tag_scene = preload("uid://cu5klpau7awvd")

func _on_pressed() -> void:
	var newtag = tag_scene.instantiate()
	$"../AddedTags/TagContainer".add_child(newtag)
	pass # Replace with function body.
