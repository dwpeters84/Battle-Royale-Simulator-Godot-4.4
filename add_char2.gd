extends HFlowContainer

@onready var new_char = preload("res://CharMaker2.tscn")

func _on_add_character_pressed() -> void:
	var character = new_char.instantiate()
	character.custom_minimum_size = Vector2(0, 356.425) 
	add_child(character)
	Cast.current_cast = get_children()
	print(Cast.current_cast)

	
