extends HFlowContainer

@onready var new_char = preload("res://FighterCreator.tscn")

func _on_add_character_pressed() -> void:
	var character = new_char.instantiate()
	add_child(character)
	Cast.current_cast = get_children()

