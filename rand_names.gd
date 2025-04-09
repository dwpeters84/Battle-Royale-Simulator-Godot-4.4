extends Button

var names = [
  "Justice", "Ash", "West", "Jesse", "Madox", "Dakota", "Cameron", "Kyle",
  "Storm", "Kim", "Erin", "Lindsay", "Jude", "Jonni", "Marley", "Ellis",
  "Lesley", "Laurel", "Jules", "Ridley", "Shane", "Tatum", "Campbell", "Jean",
  "Alexis", "Darian", "Bailey", "August", "Reed", "Maxwell", "Esme", "Roan",
  "Elis", "Stormy", "Delta", "Sam", "Sage", "Jeryn", "Freddie", "Meredith",
  "Avery", "Jaime", "Remy", "Shirley", "London", "Hailey", "Gray", "Kerry",
  "Kenzie", "Toby"
];

func randomize_names():
	names.shuffle()
	for char in %CharacterContainer.get_children():
		char.name_input.text = names.pick_random()


func _on_pressed() -> void:
	randomize_names()
	pass # Replace with function body.
