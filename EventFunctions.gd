# EventEffects.gd
# Contains the functions that implement the logic/effects for events.
# These are called by EventHandler.gd.
extends Node

# We might need RNG here too if effects have random elements independent of EventHandler
var rng = RandomNumberGenerator.new()

@onready var event_handler = $"../EventHandler"

# ================================================================
# --- DEFINE EVENT EFFECT FUNCTIONS HERE ---
# These functions MUST match the names used in the JSON file's "effect_func"
# They receive the list of participants and a reference to the EventHandler node.
# ================================================================

# --- Single Participant Effects ---
func apply_find_water(participants):
	if participants.is_empty() or not is_instance_valid(participants[0]): return
	participants[0].adjust_sanity(2)
	# Example: maybe add item
	# participants[0].add_item("Clean Water")

func apply_minor_injury(participants):
	if participants.is_empty() or not is_instance_valid(participants[0]): return
	participants[0].adjust_health(-3)
	



# --- Four Participant Effects ---
func apply_ring_around_the_rosie(participants):
	if participants.size() < 4: return

	# Require same cell?
	var first_pos = participants[0].pos if is_instance_valid(participants[0]) else null
	if first_pos == null: return # Need at least one valid char
	for i in range(1, participants.size()):
		if not is_instance_valid(participants[i]) or participants[i].pos != first_pos:
			event_handler.emit_signal("event_log_updated", "The group couldn't gather in one place to play.")
			return

	# event_handler.multiline = true # Avoid unless used

	for char in participants:
		if not is_instance_valid(char): continue
		var char_charisma = char.charisma if char.has("charisma") else 0

		var diceroll = rng.randi_range(0, 20)
		var total_score = diceroll + char_charisma
		var target_number = 13

		print("%s's roll is: %d (+%d Charisma) = %d. They needed %d to pass." % [char.char_name, diceroll, char_charisma, total_score, target_number])

		if total_score >= target_number:
			char.adjust_sanity(2)
			var success_message = "%s enjoyed the nostalgic game." % char.char_name
			event_handler.emit_signal("event_log_updated", success_message)
			print(char.char_name, " passed!")
		else:
			char.adjust_sanity(-3)
			var failure_message = "It seems that %s hates ring around the rosie..." % char.char_name
			event_handler.emit_signal("event_log_updated", failure_message)
			print(char.char_name, " failed...")
	# event_handler.multiline = false

func apply_gang_attack(participants):
	if participants.size() < 4: return
	# Assign roles carefully
	var attacker1 = participants[0]
	var attacker2 = participants[1]
	var attacker3 = participants[2]
	var defender = participants[3]

	if not (is_instance_valid(attacker1) and is_instance_valid(attacker2) and is_instance_valid(attacker3) and is_instance_valid(defender)):
		printerr("Gang attack failed: Invalid character instance.")
		return

	# Proximity Check: Attackers near defender
	if defender.pos != attacker1.pos or defender.pos != attacker2.pos or defender.pos != attacker3.pos:
		event_handler.emit_signal("event_log_updated", "The attackers couldn't coordinate their positions around %s." % defender.char_name)
		return

	# Get stats safely
	var defender_constitution = defender.constitution if defender.has("constitution") else 1
	var defender_dexterity = defender.dexterity if defender.has("dexterity") else 1
	var atk1_attack = attacker1.attack if attacker1.has("attack") else 1
	var atk2_attack = attacker2.attack if attacker2.has("attack") else 1
	var atk3_attack = attacker3.attack if attacker3.has("attack") else 1

	var diceroll = rng.randi_range(0, 20)
	var constitution_score = diceroll + defender_constitution
	# Maybe roll dexterity separately? Or use same roll? Let's use same for now.
	var dexterity_score = diceroll + defender_dexterity
	var target_number = 18

	# event_handler.multiline = true

	if dexterity_score >= target_number:
		var success_message = "They fail, as " + defender.char_name + " deftly dodges the assault!"
		event_handler.emit_signal("event_log_updated", success_message)
		print(defender.char_name, " passed with dexterity!")
	elif constitution_score >= target_number:
		var success_message = "They land blows, but " + defender.char_name + "'s endurance lessens the impact!"
		var total_attack = atk1_attack + atk2_attack + atk3_attack
		# Reduced damage calculation (example)
		var damage_taken = -2 - (total_attack / 2) # Base + half combined attack
		defender.adjust_health(damage_taken)
		event_handler.emit_signal("event_log_updated", success_message)
		print(defender.char_name, " passed with constitution!")
	else:
		var failure_message = "They overwhelm " + defender.char_name + ", dealing massive damage!!!"
		# Full damage calculation (example)
		var damage_taken = -15 - atk1_attack - atk2_attack - atk3_attack # Base + full combined attack
		defender.adjust_health(damage_taken)
		event_handler.emit_signal("event_log_updated", failure_message)
		print(defender.char_name, " failed...")

	# event_handler.multiline = false


# ================================================================
# --- OPTIONAL: DEFINE EVENT CONDITION FUNCTIONS HERE ---
# These return true or false. They also receive the EventHandler.
# ================================================================

# Example condition function
# func check_can_attack(participants: Array[Character], event_handler) -> bool:
#     if participants.size() < 2: return false
#     var attacker = participants[0]
#     var defender = participants[1]
#     if not (is_instance_valid(attacker) and is_instance_valid(defender)): return false
#     # Check for proximity
#     if attacker.pos == defender.pos:
#         return true # Simple proximity check
#     else:
#         return false
#     return false # Default deny
