extends Button

@onready var new_char = preload("res://CharMaker.tscn")


func _on_pressed() -> void:
	var new_sibling = new_char.instantiate()
	add_sibling(new_sibling)
	get_parent().move_child(self, -1)
