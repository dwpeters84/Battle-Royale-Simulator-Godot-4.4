extends HBoxContainer
@onready var r_options: OptionButton = %RelationshipOptions
var in_list: Array = []
var current_edited: Array = []

func _on_relationship_options_pressed() -> void:
	var old_selected = r_options.selected
	r_options.clear()
	in_list.clear()

	for chara in Cast.current_cast:
		var char_icon = chara.texture_rect.texture
		var char_name = chara.name_input.text
		r_options.add_icon_item(char_icon, char_name)
		
		in_list.append(chara)
	r_options.selected = old_selected

func _on_delete_pressed() -> void:
	queue_free()
