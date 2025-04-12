extends Button

@onready var new_char = preload("res://FighterCreator.tscn")

var interrupt = false

func _on_add_character_pressed() -> void:
	var character = new_char.instantiate()
	add_child(character)
	Cast.current_cast = get_children()


func _on_pressed() -> void:
	var times_to_add = int(%BulkSlider.value)
	get_viewport().gui_release_focus()
	%BlockInputRect.show()
	interrupt = false
	var chars_added = 0
	for num in range(0, times_to_add):
		if interrupt:
			break
		var character = new_char.instantiate()
		%CharacterContainer.add_child(character)
		Cast.current_cast = %CharacterContainer.get_children()
		chars_added += 1
		%BlockInputLabel.text = "Adding characters...\n%s left" % [times_to_add - chars_added]
		if chars_added % 2 == 0:
			await get_tree().process_frame
	%BlockInputRect.hide()


func _on_block_interrupt_button_pressed() -> void:
	interrupt = true
