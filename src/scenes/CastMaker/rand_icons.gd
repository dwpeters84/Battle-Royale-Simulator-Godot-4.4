extends Button

@onready var charcontainer = %CharacterContainer
var characters: Array[Character]
var textures: Array

func _ready():
	get_images()

func get_images():
	var folder_path = "res://assets/textures/char_icons/"
	var dir = DirAccess.open(folder_path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()

		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".png"):
				var file_path = folder_path + "/" + file_name
				var texture = load(file_path)
				if texture is Texture2D:
					textures.append(texture)
			file_name = dir.get_next()
		dir.list_dir_end()

###################################################################

func _on_pressed() -> void:
	randomize_images()

func randomize_images():
	textures.shuffle()
	for child in charcontainer.get_children():
		if child is Character:
			child.texture_rect.texture = textures.pick_random()
			pass
