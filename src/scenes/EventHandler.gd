# EventHandler.gd
extends Node

# Signal to send the formatted event text to the UI
signal event_log_updated(log_text)

# List of active characters (passed in from the main scene)
var characters: Array[Character] = []
var multiline: bool
var rng = RandomNumberGenerator.new()

# Define event structures
# You can expand this significantly, potentially loading from JSON/CSV later
@onready var event_data: Array = event_json()
var json_path = "res://assets/data/Events.json"
var positions = Dictionary()
@onready var grouped_chars = sort_chars_by_pos()
@onready var eventfunctions = $"../EventFunctions"

func _ready():
	if eventfunctions == null:
		printerr("EventHandler Error: Could not find EventFunctions node at ../EventFunctions")

func event_json():
	var file = FileAccess.open(json_path, FileAccess.READ)
	assert(file.file_exists(json_path), "File does not exist")
	var json = file.get_as_text()
	var json_object = JSON.new()
	json_object.parse(json)
	event_data = json_object.data
	return event_data

func set_characters(char_list: Array[Character]):
	characters = char_list
	print("EventHandler received characters: ", characters.size())

func sort_chars_by_pos():
	positions.clear()

	var alive_characters = characters.filter(func(c): return c.is_alive)

	for chara in alive_characters:
		var current_pos = chara.pos
		if positions.has(current_pos):
			positions[current_pos].append(chara) 
		else:
			positions[current_pos] = [chara] 
			
			
			
func trigger_random_event():
	print("\n--- New Event Trigger ---") 
	sort_chars_by_pos() 

	emit_signal("event_log_updated", "\n--- An hour passes... ---\n")

	var main_game = get_node_or_null("../MainGame")
	if main_game and main_game.has_method("character_movement"):
		main_game.character_movement()
	else:
		printerr("Could not find MainGame node or character_movement method.")

	var alive_characters = characters.filter(func(c): return c.is_alive)
	
	# creating a copy of alive characters is crucial for this to work
	# cuz we dont want to mess with the alive_characters list unless someone dies
	var unacted_chars = alive_characters.duplicate()
	
	# Randomize the list
	unacted_chars.shuffle()

	print("Starting event processing. Unacted characters: ", unacted_chars.size())


	# Events begin to run here. 
	# The idea is that this while loop will go through all unacted characters until everyone alive has acted.
	# This is where the problem lies, it's SOMEWHERE in here.
	
	while unacted_chars.size() > 0:
		# this starts the events off by simply picking the first person in the array and naming them as the initiator
		var initiator = unacted_chars[0] 
		var initiator_pos = initiator.pos
		var current_group = []
		
		# this is supposed to check if characters are in the same area
		# and if they are it adds them to the "current group" variable instated above
		for chara in unacted_chars:
			if chara.pos == initiator_pos:
				current_group.append(chara)
		
		
		# this is where things get fucky. 
		# the idea is that the core info for events are stored in the json file "Events.JSON"
		# from there, before we pick an event we want to check that the participant number is right
		# and then after that, if we cant run it because there's too little participants, we'll keep iterating until
		# we find an event that can host the right amount of people.
		# as a fallback maybe just implement it to where everyone in the area is forced into a 1 person event
		# idk what the fuck im doing man LOL
	
		
		var group_size = current_group.size()
		print("Processing Initiator: ", initiator.char_name, " | Group Size: ", group_size, " | Pos: ", initiator_pos, " | Unacted Left: ", unacted_chars.size())

		var suitable_events = []
		for event_dict in event_data:
			if event_dict.has("participants") and event_dict["participants"] is float and event_dict.get("participants", -1) <= group_size:
				suitable_events.append(event_dict)

		if not suitable_events.is_empty():
			var picked_event = suitable_events.pick_random()
			print("  Found exact event: ", picked_event.get("text", "MISSING TEXT"))
			var func_name_to_call = picked_event.get("effect_func", "")
			# show print pre-func call
			var format_args = {}
			for i in range(group_size):
				var chara = current_group[i]
				var prefix = "pronoun%d_" % (i + 1)
				format_args["name%d" % (i + 1)] = chara.char_name
				format_args[prefix + "subj"] = chara.pronouns.get("subj", "?") 
				format_args[prefix + "obj"] = chara.pronouns.get("obj", "?")
				format_args[prefix + "poss"] = chara.pronouns.get("poss", "?")
				format_args[prefix + "possa"] = chara.pronouns.get("possa", "?")
				format_args[prefix + "ref"] = chara.pronouns.get("ref", "?")
				format_args["health%d" % (i+1)] = chara.health 

			# format the event
			var formatted_text = picked_event.get("text", "Error: Event text missing").format(format_args, "{_}") 
			emit_signal("event_log_updated", formatted_text)

			# call the function for the event
			if not func_name_to_call.is_empty() and is_instance_valid(eventfunctions) and eventfunctions.has_method(func_name_to_call):
				print("    Calling effect function: ", func_name_to_call)
				# for this callable below, all the event logic is stored in $EventFunctions
				eventfunctions.call(func_name_to_call, current_group)
			elif not func_name_to_call.is_empty():
				printerr("    EventFunctions node is invalid or missing method: ", func_name_to_call)
		print("    Removing group from unacted list: ", current_group.map(func(c): return c.char_name))
		for participant in current_group:
			unacted_chars.erase(participant)
	
	update_map_ui()


func update_map_ui():
	var string_trim_amnt = 28
	var alive_characters = characters.filter(func(c): return c.is_alive)
	for pos in %MapTemp.get_children():
		var pos_string = pos.name.right(6)
		print(pos_string)
		var pos_container = pos.get_node("CharContainer")
		for child in pos_container.get_children():
			child.queue_free()

		for chara in alive_characters:
			print(chara.pos)
			if chara.is_alive and str(pos_string) == str(chara.pos):
				var char_icon = TextureRect.new()
				char_icon.custom_minimum_size = Vector2(24, 24)
				char_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
				char_icon.texture = chara.texture_rect.texture
				pos_container.add_child(char_icon)
