extends HFlowContainer

@onready var new_char = preload("uid://b3qowdelk5rb")

func _on_add_character_pressed() -> void:
	var character = new_char.instantiate()
	add_child(character)
	Cast.add_character(character)
