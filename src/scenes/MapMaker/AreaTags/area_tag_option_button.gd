extends HBoxContainer
signal pass_tag(tag)

var options = [
  "inside", "outside", "humid", "dry", "cold", "hot", "damp", "dusty", "dark",
  "bright", "shady", "noisy", "quiet", "echoey", "cramped", "spacious", "lofty",
  "basement", "attic", "hallway", "kitchen", "courtyard", "closet", "chapel",
  "furnace", "workshop", "library", "cave", "tunnel", "bridge", "beach", "cliffside",
  "meadow", "swamp", "forest", "jungle", "desert", "tundra", "moor", "savanna",
  "bog", "marsh", "glacier", "plateau", "valley", "gorge", "hilltop", "volcano",
  "fountain", "statue", "well", "bookshelf", "altar", "workbench", "generator",
  "ladder", "mirror", "vent", "chimney", "elevator", "socket"
]

func _ready():
	emit_signal("pass_tag", %OptionButton.get_selected())
	for tag in options:
		%OptionButton.add_item(tag)

func _on_delete_self_pressed() -> void:
	queue_free()
	pass # Replace with function body.

func _on_option_button_item_selected(index: int) -> void:
	emit_signal("pass_tag", index)
	pass # Replace with function body.
