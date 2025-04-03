extends Node

@onready var character_container = $"../Characters"
@onready var event_handler = $"../EventHandler"
@onready var trigger_button: Button = $"../Button"
@onready var event_log: RichTextLabel = $"../RichTextLabel"
var gamestarted: bool

var characters: Array[Character] = []

func add_log_entry(text: String):
	if gamestarted:
		event_log.add_text(text + "\n")
	elif event_handler.multiline == true:
		event_log.add_text(text + "\n")
	else:
		event_log.clear()
		event_log.add_text(text + "\n")
	event_log.scroll_to_line(event_log.get_line_count() - 1)
	
func _on_event_log_updated(log_text: Variant) -> void:
	add_log_entry(log_text)

func _on_character_died(character: Character):
	# Warning: This function is kinda broke atm. 
	add_log_entry("[color=red]%s has fallen.[/color]" % character.char_name)
	# Check for game over condition
	var alive_count = characters.count(func(c): return c.is_alive)
	add_log_entry("%d tributes remain." % alive_count)

	if alive_count >= 1:
		trigger_button.disabled = true # Stop triggering events

		# Find the INDEX of the winner
		var winner_index : int = characters.find(func(c): return c.is_alive)

		# Check if an index was found (find returns -1 if not found)
		if winner_index != -1:
			# Get the actual Character object using the index
			var winner_character : Character = characters[winner_index]
			# Now access char_name on the Character object
			add_log_entry("[color=green][b]%s is the victor![/b][/color]" % winner_character.char_name)
		else:
			# This handles the case where alive_count is 0 (no survivors)
			add_log_entry("[color=orange]There are no survivors.[/color]")

func _on_character_health_changed(character: Character, new_health: int, max_health: int):
	print("%s health is now %d/%d" % [character.char_name, new_health, max_health])


func _on_start_game_pressed() -> void:
	for child in character_container.get_children():
		if child is Character: # Type check using class_name
			characters.append(child)
			child.died.connect(_on_character_died)
			child.health_changed.connect(_on_character_health_changed)
	if characters.is_empty():
		printerr("No Character nodes found!")
		return

	print("MainGame found %d characters." % characters.size())

	event_handler.set_characters(characters)

	trigger_button.pressed.connect(event_handler.trigger_random_event)

	event_log.clear()
	gamestarted = true
	add_log_entry("the swag games begin....")
	for char in characters:
		add_log_entry("%s enters the arena." % char.char_name)
	gamestarted = false
