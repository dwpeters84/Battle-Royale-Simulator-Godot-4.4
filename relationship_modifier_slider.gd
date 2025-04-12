extends Label

func _on_relationship_slider_value_changed(value: float) -> void:
	set_text(str(int(value)))
