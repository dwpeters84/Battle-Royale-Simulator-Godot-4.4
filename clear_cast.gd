extends Button

func _on_pressed() -> void:
	$AcceptDialog.popup()

func _on_accept_dialog_confirmed() -> void:
	for child in %CharacterContainer.get_children():
		child.queue_free()
