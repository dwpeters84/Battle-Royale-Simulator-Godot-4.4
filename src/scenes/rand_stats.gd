extends Button

func randomize_stats():
	for child in %CharacterContainer.get_children():
		for stat in child.editstats.get_children():
			stat._on_value_changed(randi_range(1,5))

func _on_pressed() -> void:
	randomize_stats()
