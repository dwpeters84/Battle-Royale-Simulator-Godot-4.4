extends Button

func _on_pressed() -> void:
	$AcceptDialog.popup()

func _on_accept_dialog_confirmed() -> void:
	for child in %CharacterContainer.get_children():
		Cast.current_cast.erase(child)
		child.queue_free()
