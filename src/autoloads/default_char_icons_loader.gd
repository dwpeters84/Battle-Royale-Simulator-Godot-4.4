extends Node

@export var char_icons: Array

func _ready():
	var folder_path = "res://assets/textures/char_icons/"
	for file_name in DirAccess.get_files_at(folder_path):
		
		if file_name.get_extension() == "import":
			file_name = file_name.trim_suffix(".import")
		 
		if file_name.get_extension() == "png":
			var texture := load(folder_path + file_name)
			if texture is Texture2D:
				char_icons.append(texture)
		elif file_name.get_extension() in ["res", "tres"]:
			var resource := load(folder_path + file_name)
			if resource is Texture2D:
				char_icons.append(resource)
