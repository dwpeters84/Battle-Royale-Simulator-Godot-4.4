extends Button

@onready var new_char = preload("res://FighterCreator.tscn")

func _on_add_character_pressed() -> void:
	var character = new_char.instantiate()
	character.custom_minimum_size = Vector2(0, 356.425) 
	add_child(character)
	Cast.current_cast = get_children()


func _on_pressed() -> void:
	var times_to_add = int(%BulkLabel.text)

	for num in range(0, times_to_add):
		var character = new_char.instantiate()
		character.custom_minimum_size = Vector2(0, 356.425) 
		%CharacterContainer.add_child(character)
		Cast.current_cast = %CharacterContainer.get_children()
	
