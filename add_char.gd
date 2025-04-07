extends Button

@onready var new_char = preload("res://CharMaker.tscn")


func _on_pressed() -> void:
	var new_sibling = Panel.new()
	add_sibling(new_sibling)
	new_sibling.custom_minimum_size = Vector2(195.815, 332.595)
	
	
	var new_char_instance = new_char.instantiate()
	new_sibling.call_deferred("add_child", new_char_instance)
	new_char_instance.position = Vector2(95, 181)
	
	get_parent().move_child(self, -1)
