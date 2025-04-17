extends Button

var names = [
  "Justice", "Ash", "West", "Jesse", "Madox", "Dakota", "Cameron", "Kyle",
  "Storm", "Kim", "Erin", "Lindsay", "Jude", "Jonni", "Marley", "Ellis",
  "Lesley", "Laurel", "Jules", "Ridley", "Shane", "Tatum", "Campbell", "Jean",
  "Alexis", "Darian", "Bailey", "August", "Reed", "Maxwell", "Esme", "Roan",
  "Elis", "Stormy", "Delta", "Sam", "Sage", "Jeryn", "Freddie", "Meredith",
  "Avery", "Jaime", "Remy", "Shirley", "London", "Hailey", "Gray", "Kerry",
  "Kenzie", "Toby", "Benji"
];

func randomize_names():
	var picked_name
	var picked_names: Array
	names.shuffle()
	for char in %CharacterContainer.get_children():
		if not picked_names.has(picked_name):
			picked_name = names.pick_random()
			picked_names.append(picked_name)
		else:
			names.shuffle()
			picked_name = names.pick_random()
		char.name_input.text = picked_name
		char.name_input.text_changed.emit(picked_name)


func _on_pressed() -> void:
	randomize_names()
	pass # Replace with function body.
