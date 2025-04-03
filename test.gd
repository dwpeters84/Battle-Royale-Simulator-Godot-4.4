extends Node

signal event_log_updated(log_text)

var characters: Array[Character] = []
var multiline: bool
var rng = RandomNumberGenerator.new()

var events = [
	{
		"id": "find_water",
		"participants": 1,
		"text": "{name1} found a fresh spring. {pronoun1_subj} quenched {pronoun1_poss} thirst.",
		"effect": func(chars: Array[Character]): chars[0].adjust_sanity(2)
			# Maybe add 'water' to inventory later
	},
	{
		"id": "minor_injury",
		"participants": 1,
		"text": "{name1} tripped over a root, scraping {pronoun1_poss} knee.",
		"effect": func(chars: Array[Character]): chars[0].adjust_health(-3)
	},
	{
		"id": "ominous_sound",
		"participants": 1,
		"text": "{name1} heard a terrifying scream nearby. {pronoun1_subj} felt a chill run down {pronoun1_poss} spine.",
		"effect": func(chars: Array[Character]): chars[0].adjust_sanity(-5)
	},
	{
		"id": "minor_scuffle",
		"participants": 2,
		"text": "{name1} and {name2} got into a brief argument over supplies.",
		"effect": func(chars: Array[Character]): chars[0].adjust_sanity(-1) 
	},
	{
		"id": "attack_event",
		"participants": 2,
		"text": "{name1} lunged at {name2} with a makeshift weapon! {pronoun1_subj} attacked!",
		"effect": func(chars: Array[Character]): 
			var attacker = chars[0]
			var defender = chars[1]
			# Simple combat example (replace with your desired combat logic)
			var damage = max(0, attacker.attack - defender.defense + randi_range(-2, 2))
			defender.adjust_health(-damage)
},#Ignoring the comment below and using the rest of the script as an example, come up with some random events.

	{
		"id": "animal_attack",
		"participants": 1,
		"text": "{name1} was attacked by a wild animal. {pronoun1_subj} fought bravely.",
		"effect": func(chars: Array[Character]): chars[0].adjust_health(-5)
	},
	{
		"id": "find_shelter",
		"participants": 2,
		"text": "{name1} and {name2} found a cave to take shelter from the rain.",
		"effect": func(chars: Array[Character]): chars[0].adjust_sanity(1)
	},
	
	{
		"id": "teamwork",
		"participants": 2,
		"text": "{name1} and {name2} decided to work together to build a fire.",
		"effect": func(chars: Array[Character]): 
			var teammate1 = chars[0]
			var teammate2 = chars[1]
			teammate1.adjust_sanity(1)
			teammate2.adjust_sanity(1)
			},
			
{
		"id": "ring_around_the_rosie",
		"participants": 4,
		"text": "{name1}, {name2}, {name3} and {name4} play ring around the rosie...",
		"effect": func(chars: Array[Character]):
			multiline = true

			for char in chars:
				var diceroll = randi_range(0, 20) 
				var total_score = diceroll + char.charisma
				var target_number = 13 

				print("%s's roll is: %d (+%d Charisma) = %d. They needed %d to pass." % [char.char_name, diceroll, char.charisma, total_score, target_number]) # More informative print

				if total_score >= target_number:
					char.adjust_sanity(2)
					var success_message = "%s enjoyed the nostalgic game." % char.char_name
					emit_signal("event_log_updated", success_message)
					print(char.char_name, " passed!")
				else:
					char.adjust_sanity(-3)
					var failure_message = "It seems that %s hates ring around the rosie..." % char.char_name
					emit_signal("event_log_updated", failure_message)
					print(char.char_name, " failed...")
			multiline = false
					},
{
		"id": "gangbang",
		"participants": 4,
		"text": "{name1}, {name2}, {name3} gang up on {name4}, attempting to beat {pronoun4_poss} senseless",
		"effect": func(chars: Array[Character]):
			
			var attacker1 = chars[0]
			var attacker2 = chars[1]
			var attacker3 = chars[2]
			var defender = chars[3]
			
			var diceroll = randi_range(0, 20) 
			var total_score = diceroll + defender.constitution
			var total_score2 = diceroll + defender.dexterity
			var target_number = 18 
			
			multiline = true

			if total_score2 >= target_number:
				var success_message = "They fail, as " + defender.char_name + " manages to get away before they can touch 'em!"
				emit_signal("event_log_updated", success_message)
				print(defender.char_name, " passed with dexterity!")
			elif total_score >= target_number:
				var success_message = "They deal a lot of damage, but not as much as they could due to  " + defender.char_name + "'s great endurance!"
				defender.adjust_health(-2 + (-attacker1.strength) + (-attacker2.strength) + (-attacker3.strength))
				emit_signal("event_log_updated", success_message)
				print(defender.char_name, " passed with consitution!")
			else:
				defender.adjust_health(-15 + (-attacker1.strength) + (-attacker2.strength) + (-attacker3.strength))
				var failure_message = "They succeed, dealing massive damage to   " + defender.char_name + "!!!"
				emit_signal("event_log_updated", failure_message)
				print(defender.char_name, " failed...")
			multiline = false
					} 


]


func set_characters(char_list: Array[Character]):
	characters = char_list
	print("EventHandler received characters: ", characters.size())

# Called when the button is pressed
func trigger_random_event():
	var alive_characters = characters.filter(func(c): return c.is_alive)

	if alive_characters.size() < 1:
		print("No characters alive to trigger an event.")
		emit_signal("event_log_updated", "The arena falls silent...")
		return

	# Filter events that can happen based on participant count and conditions
	var possible_events = []
	for event_data in events:
		var required_participants = event_data["participants"]
		if alive_characters.size() >= required_participants:
			# Check condition if it exists
			if event_data.has("condition"):
				 # Need to temporarily pick characters to test condition
				var temp_participants = select_participants(alive_characters, required_participants)
				
				if temp_participants and event_data["condition"].call(temp_participants):
					possible_events.append(event_data)
				 # Note: selecting temp participants isn't perfect if the condition depends heavily on *specific* pairs, but it's a good approximation.
			else:
				possible_events.append(event_data)


	if possible_events.is_empty():
		print("No suitable events found for the current number of alive characters.")
		# Maybe a default "nothing happens" event?
		emit_signal("event_log_updated", "A tense quiet hangs in the air.")
		return

	# Select a random event from the possible ones
	var chosen_event = possible_events.pick_random()
	var num_participants = chosen_event["participants"]

	# Select distinct participants for the event
	var participants = select_participants(alive_characters, num_participants)
	if not participants:
		printerr("Failed to select distinct participants for event: ", chosen_event["id"])
		return # Should not happen if filtering worked, but safety check

	print("Triggering Event: %s for %s" % [chosen_event["id"], participants.map(func(p): return p.char_name)])

	# Format the event text
	var format_args = {}
	for i in range(participants.size()):
		var char = participants[i]
		var prefix = "pronoun%d_" % (i + 1)
		format_args["name%d" % (i + 1)] = char.char_name
		format_args[prefix + "subj"] = char.pronouns["subj"]
		format_args[prefix + "obj"] = char.pronouns["obj"]
		format_args[prefix + "poss"] = char.pronouns["poss"]
		format_args[prefix + "possa"] = char.pronouns["possa"]
		format_args[prefix + "ref"] = char.pronouns["ref"]

		format_args["health%d" % (i+1)] = char.health

	var formatted_text = chosen_event["text"].format(format_args, "{_}")

	emit_signal("event_log_updated", formatted_text)

	if chosen_event.has("effect"):
		chosen_event["effect"].call(participants) 

func select_participants(char_pool: Array[Character], count: int) -> Array[Character]:
	if count > char_pool.size():
		return []
	
	var selected: Array[Character] = []
	var available = char_pool.duplicate() 
	available.shuffle() 
	
	for i in range(count):
		if available.is_empty(): 
			printerr("Error selecting participants: pool emptied unexpectedly.")
			return []
		selected.append(available.pop_front())
		
	return selected
