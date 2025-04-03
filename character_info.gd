extends Node2D
class_name Character

# Signal emitted when the character's health reaches zero or below
signal died(character)
# Signal emitted when health changes (useful for UI updates)
signal health_changed(character, new_health, max_health)
# Signal emitted when sanity changes
signal sanity_changed(character, new_sanity, max_sanity)
# Signal emitted when stats are finalized after selection
signal stats_finalized(character)

# Basic Info
var char_name: String = "Tribute" : set = set_char_name
var unique_id: String = "" # Can be set externally or generated

var available_pronouns = {"he/him": {"subj": "he", "obj": "him", "poss": "his", "possa": "his", "ref": "himself"}, # poss=possessive determiner (his sword), possa=possessive pronoun (the sword is his), ref=reflexive
						 "she/her": {"subj": "she", "obj": "her", "poss": "her", "possa": "hers", "ref": "herself"},
						 "they/them": {"subj": "they", "obj": "them", "poss": "their", "possa": "theirs", "ref": "themselves"},
						 "it/its": {"subj": "it", "obj": "it", "poss": "its", "possa": "its", "ref": "itself"} # Simplified "it/they" to "it/its" for now
						 }
var picked_pronoun_key: String = "they/them"
var pronouns: Dictionary = available_pronouns[picked_pronoun_key]

var builds = {
	"Obese": {"str_mod": 5, "dex_mod": 1, "con_mod": 4},
	"Overweight": {"str_mod": 4, "dex_mod": 2, "con_mod": 3},
	"Chubby": {"str_mod": 3, "dex_mod": 2, "con_mod": 3},
	"Average": {"str_mod": 2, "dex_mod": 3, "con_mod": 3},
	"Underweight": {"str_mod": 2, "dex_mod": 3, "con_mod": 1},
	"Fit": {"str_mod": 2, "dex_mod": 4, "con_mod": 4},
	"Burly": {"str_mod": 5, "dex_mod": 2, "con_mod": 3},
	"Superhuman": {"str_mod": 6, "dex_mod": 6, "con_mod": 6},
	"Muscular": {"str_mod": 4, "dex_mod": 3, "con_mod": 3}
	}

var personalities = {
	"Goofy": {"int_mod": 0, "wis_mod": 4, "chr_mod": 5},
	"Nerdy": {"int_mod": 7, "wis_mod": 6, "chr_mod": 5},
	"Genius": {"int_mod": 10, "wis_mod": 8, "chr_mod": 3},
	"Idiot": {"int_mod": 0, "wis_mod": 1, "chr_mod": 3},
	"Charismatic": {"int_mod": 3, "wis_mod": 3, "chr_mod": 7},
	"Philosophical": {"int_mod": 2, "wis_mod": 7, "chr_mod": 4},
	"Suave": {"int_mod": 3, "wis_mod": 5, "chr_mod": 5},
	"Empathetic": {"int_mod": 0, "wis_mod": 0, "chr_mod": 0},
	"Evil": {"int_mod": 0, "wis_mod": 0, "chr_mod": 0},
	"Asshole": {"int_mod": 0, "wis_mod": 0, "chr_mod": 0},
	"Mischievous": {"int_mod": 0, "wis_mod": 0, "chr_mod": 0},
	"Kind": {"int_mod": 0, "wis_mod": 0, "chr_mod": 0},
	"Brave": {"int_mod": 0, "wis_mod": 0, "chr_mod": 0},
	"Shy": {"int_mod": 0, "wis_mod": 0, "chr_mod": 0},
	"Dramatic": {"int_mod": 0, "wis_mod": 0, "chr_mod": 0},
	"Calm": {"int_mod": 3, "wis_mod": 5, "chr_mod": 2},
	"Adventurous": {"int_mod": 3, "wis_mod": 2, "chr_mod": 5},
	"Lazy": {"int_mod": 1, "wis_mod": 1, "chr_mod": 2}
	}

# Core Stats
var strength: int = 1
var dexterity: int = 1
var constitution: int = 1
var intelligence: int = 1
var wisdom: int = 1
var charisma: int = 1

# Derived Stats
var max_health: int = 10
var health: int = 10 : set = set_health
var max_sanity: int = 10
var sanity: int = 10 : set = set_sanity

var attack: int = 1
var defense: int = 1

var is_alive: bool = true
var inventory: Array = [] # For items later

@onready var name_input: TextEdit = $NameInput
@onready var pronouns_button: OptionButton = $PronounsButton
@onready var personality_button: OptionButton = $PersonalityButton
@onready var builds_button: OptionButton = $BuildsButton
@onready var health_label: RichTextLabel = $Health
@onready var sanity_label: RichTextLabel = $Sanity
@onready var texture_rect: TextureRect = $CharIcon
@onready var file_dialog: FileDialog = $FileDialog

# --- Initialization ---
func _ready() -> void:
	unique_id = str(get_instance_id()) #just in case

	# Populate Dropdowns
	for key in available_pronouns:
		pronouns_button.add_item(key)
	# Select default or potentially saved value
	var default_pronoun_idx = -1 # Initialize to -1 (not found)
	for i in range(pronouns_button.item_count):
		if pronouns_button.get_item_text(i) == picked_pronoun_key:
			default_pronoun_idx = i
			break # Exit loop once found

	if default_pronoun_idx != -1:
		pronouns_button.select(default_pronoun_idx)
	else:

		printerr("Default pronoun key '%s' not found in OptionButton items." % picked_pronoun_key)
		if pronouns_button.item_count > 0:
			pronouns_button.select(0) 
			_on_pronoun_selected(0) 
		else:
			printerr("Pronoun OptionButton has no items!")

	for personality in personalities:
		personality_button.add_item(personality)

	for build in builds:
		builds_button.add_item(build)

	pronouns_button.item_selected.connect(_on_pronoun_selected)
	personality_button.item_selected.connect(on_selection_changed)
	builds_button.item_selected.connect(on_selection_changed)
	name_input.text_changed.connect(_on_name_input_text_changed)


	calculate_stats()
	update_ui_labels()


func set_char_name(new_name: String):
	print("set_char_name: Received:", new_name) 
	var potential_name = new_name.strip_edges() 
	if potential_name.is_empty():
		potential_name = "Tribute" # Default if empty

	if char_name != potential_name:
		char_name = potential_name
		print("set_char_name: char_name is now:", char_name)

func set_health(value: int):
	var previous_health = health
	health = clamp(value, 0, max_health) # Ensure health doesn't go below 0 or above max
	if health != previous_health:
		health_changed.emit(self, health, max_health)
		update_ui_labels()
		if health <= 0 and is_alive:
			die()

func set_sanity(value: int):
	var previous_sanity = sanity
	sanity = clamp(value, 0, max_sanity)
	if sanity != previous_sanity:
		sanity_changed.emit(self, sanity, max_sanity)
		update_ui_labels()


func calculate_stats():
	strength = 1
	dexterity = 1
	constitution = 1
	intelligence = 1
	wisdom = 1
	charisma = 1

	# Apply mods from selected build
	var selected_build = builds_button.get_item_text(builds_button.selected)
	if builds.has(selected_build):
		var build_mods = builds[selected_build]
		strength += build_mods["str_mod"]
		dexterity += build_mods["dex_mod"]
		constitution += build_mods["con_mod"]

	# Apply mods from selected personality
	var selected_personality = personality_button.get_item_text(personality_button.selected)
	if personalities.has(selected_personality):
		var personality_mods = personalities[selected_personality]
		intelligence += personality_mods["int_mod"]
		wisdom += personality_mods["wis_mod"]
		charisma += personality_mods["chr_mod"]

	# Calculate derived stats. All formulas are subject to change.
	max_health = 5 + (constitution * 5) + (strength * 2) 
	max_sanity = 5 + (intelligence * 3) + (wisdom * 3) 
	health = max_health
	sanity = max_sanity
	attack = 2 + strength + (dexterity / 2) 
	defense = 1 + dexterity + (constitution / 2)

	# Reset health/sanity to new max if they haven't been damaged yet
	# Or potentially scale current health/sanity if desired
	if health == max_health or health > max_health: # Simple reset if at full or stats increased
		set_health(max_health) # Use setter to ensure signals/clamping
	if sanity == max_sanity or sanity > max_sanity:
		set_sanity(max_sanity) # Use setter

	update_ui_labels()
	stats_finalized.emit(self) # Notify parent potentially

func update_ui_labels():
	if health_label: 
		health_label.text = "HEALTH: %d/%d" % [health, max_health]
	if sanity_label:
		sanity_label.text = "SANITY: %d/%d" % [sanity, max_sanity]

func die():
	if is_alive:
		print("%s has died." % char_name)
		is_alive = false
		died.emit(self) # Emit signal *after* setting is_alive

func adjust_health(amount: int):
	print("%s health changes by %d" % [char_name, amount])
	set_health(health + amount) 

func adjust_sanity(amount: int):
	print("%s sanity changes by %d" % [char_name, amount])
	set_sanity(sanity + amount) 

func add_item(item_name: String):
	inventory.append(item_name)
	print("%s received item: %s" % [char_name, item_name])


func remove_item(item_name: String):
	if item_name in inventory:
		inventory.erase(item_name)
		print("%s lost item: %s" % [char_name, item_name])
		return true
	return false

# --- Signal Callbacks ---
func _on_name_input_text_changed() -> void:
	print("_on_name_input_text_changed: Input text is now:", name_input.text)
	var current_input_text = name_input.text.strip_edges()
	if current_input_text.is_empty():
		char_name = "Tribute"
	else:
		char_name = current_input_text
	print("_on_name_input_text_changed: char_name updated to:", char_name)
	
func _on_pronoun_selected(index: int) -> void:
	picked_pronoun_key = pronouns_button.get_item_text(index)
	if available_pronouns.has(picked_pronoun_key):
		pronouns = available_pronouns[picked_pronoun_key]
		print("%s pronouns set to: %s" % [char_name, picked_pronoun_key])
	else:
		printerr("Selected pronoun key not found in available_pronouns: ", picked_pronoun_key)
		# Fallback to default if something went wrong
		picked_pronoun_key = "they/them"
		pronouns = available_pronouns[picked_pronoun_key]


func on_selection_changed(index: int) -> void:
	calculate_stats()

func _on_change_char_icon_pressed() -> void:
	file_dialog.popup_centered()

func _on_img_picked(path: String) -> void:
	var image = Image.load_from_file(path)
	if image:
		var texture = ImageTexture.create_from_image(image)
		texture_rect.texture = texture
		print("Image loaded successfully for %s from: %s" % [char_name, path])
	else:
		printerr("Failed to load image for %s from: %s" % [char_name, path])
