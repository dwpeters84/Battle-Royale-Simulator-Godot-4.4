extends Control
class_name Character

# Signal emitted when the character's health reaches zero or below
signal died(character)
# Signal emitted when health changes (useful for UI updates)
signal health_changed(character, new_health, max_health)
# Signal emitted when sanity changes
signal sanity_changed(character, new_sanity, max_sanity)
# Signal emitted when stats are finalized after selection
signal stats_finalized(character)
# Signal emitted when icon is changed
signal icon_changed
# Signal emitted when name is changed
signal name_changed(new_name)
# Signal emitted when stats are changed
signal stats_changed


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

# Core Stats
var form: int = 1
var endurance: int = 1
var perception: int = 1
var ingenuity: int = 1
var charisma: int = 1

# Derived Stats
var max_health: int = 10
var health: int = 10 : set = set_health
var max_sanity: int = 10
var sanity: int = 10 : set = set_sanity

var attack: int = 1
var defense: int = 1

var is_alive: bool
var inventory: Array = [] # For items later

@onready var name_input: LineEdit = %NameInput
@onready var pronouns_button: OptionButton = %PronounsButton
@onready var name_label: RichTextLabel = %NameLabel
@onready var health_label: RichTextLabel = %Health
@onready var sanity_label: RichTextLabel = %Sanity
@onready var health_bar = %HealthBar
@onready var sanity_bar = %SanityBar
@onready var texture_rect: TextureRect = %CharIcon
@onready var icon_texture = %CharIcon.texture
@onready var file_dialog: FileDialog = %FileDialog
@onready var confirmation_dialog: ConfirmationDialog = %ConfirmationDialog
@onready var change_img = %ChangeCharIcon
@onready var delete_char = %DeleteButton
@onready var edit_controls = %EditControls
@onready var bars = %Bars
@onready var Nametag = %Nametag

@onready var editstats = %EditStats

@onready var relationship_window = %RelationshipWindow

#stats
@onready var form_slider = %FormSlider
@onready var endurance_slider = %EnduranceSlider
@onready var perception_slider = %PerceptionSlider
@onready var ingenuity_slider = %IngenuitySlider
@onready var charisma_slider = %CharismaSlider
#/stats

@onready var MainGameController = get_tree().get_first_node_in_group("GameControllers")

var pos = Vector2i(0,0)
var roll
	
@onready var relationship_container: Node = %RelationshipContainer

# --- Initialization ---
func _ready() -> void:

	#pos.x = randi_range(0, MainGameController.map_size_maximum_x)
	#pos.y = randi_range(0, MainGameController.map_size_maximum_y)

	is_alive = true
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

	pronouns_button.item_selected.connect(_on_pronoun_selected)
	# stats
	form_slider.value_changed.connect(on_value_changed)
	endurance_slider.value_changed.connect(on_value_changed)
	perception_slider.value_changed.connect(on_value_changed)
	ingenuity_slider.value_changed.connect(on_value_changed)
	charisma_slider.value_changed.connect(on_value_changed)
	# /stats
	name_input.text_changed.connect(_on_name_input_text_changed)
	change_img.pressed.connect(_on_change_char_icon_pressed)
	delete_char.pressed.connect(_on_delete_button_pressed)
	confirmation_dialog.confirmed.connect(confirm_delete)
	file_dialog.file_selected.connect(_on_img_picked)


	calculate_stats()
	update_ui_labels()

func move(move_x, move_y):
	if is_alive:
		pos.x += move_x
		pos.y += move_y
		print(char_name, " has moved ", pos)
	else:
		print(char_name + " cannot move because they're dead, lol.")
	
func set_char_name(new_name: String):
	var potential_name = new_name.strip_edges() 
	if potential_name.is_empty():
		potential_name = "Tribute" # Default if empty

	if char_name != potential_name:
		char_name = potential_name

#	name_label.text = "[center][font_size=22]" + char_name + "[/font_size][/center]"

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
	form = form_slider.stat_value
	endurance = endurance_slider.stat_value
	perception = perception_slider.stat_value
	ingenuity = ingenuity_slider.stat_value
	charisma = charisma_slider.stat_value

	# Calculate derived stats. All formulas are subject to change.
	max_health = 5 + (form * 5) + (endurance * 2) + ingenuity
	max_sanity = 5 + (perception * 3) + (charisma * 3) + ingenuity
	health = max_health
	sanity = max_sanity
	attack = 2 + form + (ingenuity / 2) 
	defense = 1 + endurance + (ingenuity / 2)

	# Reset health/sanity to new max if they haven't been damaged yet
	# Or potentially scale current health/sanity if desired
	if health == max_health or health > max_health: # Simple reset if at full or stats increased
		set_health(max_health) # Use setter to ensure signals/clamping
	if sanity == max_sanity or sanity > max_sanity:
		set_sanity(max_sanity) # Use setter

	emit_signal("stats_changed")
	stats_finalized.emit(self) # Notify parent potentially

func update_ui_labels():
	if health_label: 
		health_bar.max_value = max_health
		health_bar.value = health
		health_label.text = "[center]HEALTH: %d/%d[/center]" % [health, max_health]
	if sanity_label:
		sanity_bar.max_value = max_sanity
		sanity_bar.value = sanity
		sanity_label.text = "[center]SANITY: %d/%d[/center]" % [sanity, max_sanity]

func die():
	if is_alive:
		is_alive = false
		var deadimg = Image.load_from_file("res://char_icons/dead.png")
		var texture = ImageTexture.create_from_image(deadimg)
		texture_rect.texture = texture
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
func _on_name_input_text_changed(new_text) -> void:
	set_char_name(new_text)
	emit_signal("name_changed")
	
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


func on_value_changed(_value: int) -> void:
	calculate_stats()

func _on_change_char_icon_pressed() -> void:
	file_dialog.popup_centered()

func _on_img_picked(path: String) -> void:
	var image = Image.load_from_file(path)
	if image:
		var texture = ImageTexture.create_from_image(image)
		texture_rect.texture = texture
		print("Image loaded successfully for %s from: %s" % [char_name, path])
		emit_signal("icon_changed")
	else:
		printerr("Failed to load image for %s from: %s" % [char_name, path])

func toggle_ui(toggle):
	edit_controls.visible = not toggle
	change_img.visible = not toggle
	delete_char.visible = not toggle
	%StreamImage.visible = not toggle
	
	Nametag.text = char_name
	Nametag.visible = toggle


func _on_delete_button_pressed() -> void:
	confirmation_dialog.popup()

func confirm_delete() -> void:
	Cast.current_cast.erase(self)
	queue_free()


func _on_relationship_editor_pressed() -> void:
	relationship_window.popup()
	relationship_window.title = "Relationships for " + char_name
