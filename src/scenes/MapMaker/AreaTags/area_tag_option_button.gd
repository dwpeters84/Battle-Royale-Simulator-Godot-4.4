extends HBoxContainer

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
	for tag in options:
		%OptionButton.add_item(tag)
