extends Button

func _on_pressed() -> void:
	%RandIcons.randomize_images()
	%RandStats.randomize_stats()
	%RandNames.randomize_names()
	pass # Replace with function body.
