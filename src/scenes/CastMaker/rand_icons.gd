extends Button

@onready var charcontainer = %CharacterContainer
var characters: Array[Character]
var textures: Array

func _ready():
	get_images()

func get_images():
	textures = DefaultCharIcons.char_icons

###################################################################

func _on_pressed() -> void:
	randomize_images()

func randomize_images():
	textures.shuffle()
	for child in charcontainer.get_children():
		if child is Character:
			child.texture_rect.texture = textures.pick_random()
			pass
