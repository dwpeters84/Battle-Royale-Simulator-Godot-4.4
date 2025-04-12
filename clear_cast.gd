extends Button

func _on_pressed() -> void:
	$AcceptDialog.popup()
	pass # Replace with function body.

func _on_accept_dialog_confirmed() -> void:
	for child in %CharacterContainer.get_children():
		child.queue_free()
	pass # Replace with function body.
