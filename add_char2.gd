extends HFlowContainer

@onready var new_char = preload("res://CharMaker2.tscn")
@onready var relationship_scene = preload("res://RelationshipEditor.tscn")
var current_cast = []

func _on_add_character_pressed() -> void:
	var character = new_char.instantiate()
	character.custom_minimum_size = Vector2(0, 356.425) 
	add_child(character)
	
	############################ everything commeneted out below is busted atm #############################################
	
	#add_relationship(character)
	#update_relationships()
	#
#func add_relationship(character):
	#pass	
#
#
#func update_relationships():
	#var relationship_slider
	#var erased
#
	#for char in get_children():
		#relationship_slider = relationship_scene.instantiate()
		#char.relationship_container.add_child(relationship_slider)
		#
		##adds all current characters to current_cast array
		#current_cast.append(char)
		#
	#for char in current_cast:
		#if current_cast.has(erased):
		##iterates through the current_cast array
			#
			#for member in current_cast:
				##removes the character currently being iterated through so they dont add themselves to their relationships
				#current_cast.erase(member)
				##set the erased person to a variable so we don't lose them when we loop again
				#erased = member
				#
				#for dude in current_cast:
					##updates the icons of everyone else
					#relationship_slider.update_icon(char.texture_rect.texture)
					#char.relationships[str(dude)] = 0
					#
				##adds the erased person back into the array after updating the textures and dictionaries of the others
				#current_cast.append(member)
		#else:
			#print("no")
