extends Node

var map_size_minimum_y: int = 0
var map_size_minimum_x: int = 0
@export var map_size_maximum_y: int = 2
@export var map_size_maximum_x: int = 2
@export var move_check = 15

@onready var character_container = %Characters
@onready var event_handler = %EventHandler
@onready var trigger_button: Button = %TriggerEventButton
@onready var event_log: RichTextLabel = %GameLog
var gamestarted: bool

var characters: Array[Character] = []

func add_log_entry(text: String):
	if gamestarted:
		event_log.append_text(text + "\n")
	else:
		event_log.append_text(text + "\n")
	event_log.scroll_to_line(event_log.get_line_count() - 1)
	
	
func _on_event_log_updated(log_text: Variant) -> void:
	add_log_entry("[center][font_size=20]" + log_text + "[/font_size][/center]")

func _on_character_died(character: Character):
	add_log_entry("[center][color=red][font_size=20]%s has fallen.[/font_size][/color][/center]" % character.char_name)
	var alive_count = 0
	for char in characters:
		if char.is_alive:
			alive_count += 1
			print(char.char_name, " is still alive!")
		else:
			print(char.char_name, " is dead!")
	add_log_entry("[center]%d tributes remain.[/center]" % alive_count)

	if alive_count <= 1:
		trigger_button.disabled = true # Stop triggering events

		# Find the INDEX of the winner
		var winner_index : int =-1
		for i in characters.size():
			if characters[i].is_alive:
				winner_index = i
				break

		if winner_index != -1:
			var winner_character : Character = characters[winner_index]
			add_log_entry("[color=green][b][font_size=35][center]%s is the victor![/center][/font_size][/b][/color]" % winner_character.char_name)
		else:
			# This handles the case where alive_count is 0 (no survivors)
			add_log_entry("[color=orange][center][font_size=20]There are no survivors.[/font_size][/center][/color]")

func _on_character_health_changed(character: Character, new_health: int, max_health: int):
	print("%s health is now %d/%d" % [character.char_name, new_health, max_health])


func _on_start_game_pressed() -> void:
	characters.clear()
	_find_characters(character_container)

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
	
	for character in characters:
		character.toggle_ui(true)
	
	event_handler.update_map_ui()
	
func _find_characters(node: Node) -> void:
	for child in node.get_children():
		if child is Character:
			print(child.char_name, " is ready for battle! Their current position is ", child.pos)
			characters.append(child)
			child.died.connect(_on_character_died)
			child.health_changed.connect(_on_character_health_changed)
		elif child.get_child_count() > 0:
			_find_characters(child) # Recurse into child

func character_movement():
	var move_y
	var move_x
	
	for char in characters:
		
		move_y = 0
		move_x = 0
		var roll = randi_range(1,20)
		if roll >= move_check:
			var roll2 = randi_range(1,4)
			
			if roll2 == 1:
				move_y = 1
				print(char.char_name, " attempts to move to ", (char.pos.x + move_x), ",", (char.pos.y + move_y))
			elif roll2 == 2:
				move_x = 1
				print(char.char_name, " attempts to move to ", (char.pos.x + move_x), ",", (char.pos.y + move_y))
			elif roll2 == 3:
				move_y = -1
				print(char.char_name, " attempts to move to ", (char.pos.x + move_x), ",", (char.pos.y + move_y))
			elif roll2 == 4:
				move_x = -1
				print(char.char_name, " attempts to move to ", (char.pos.x + move_x), ",", (char.pos.y + move_y))
				
			if check_valid_movement((char.pos.x + move_x), (char.pos.y + move_y)) == true:
				char.move(move_x, move_y)
			else:
				print(char.char_name, " tries to move, but can't.")
		else:
			print(char.char_name, " decides not to move.")
				
func check_valid_movement(x, y):
	if x >= map_size_minimum_x and x <= map_size_maximum_x and y >= map_size_minimum_y and y <= map_size_maximum_y:
		return true
	else:
		return false
