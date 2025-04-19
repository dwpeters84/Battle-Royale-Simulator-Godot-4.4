extends Node

@export var items: Dictionary

func _ready():
	var folder_path = "res://assets/textures/items/"
	for file_name in DirAccess.get_files_at(folder_path):
		
		if file_name.get_extension() == "import":
			file_name = file_name.trim_suffix(".import")
		
		if file_name.get_extension() == "png":
			var texture := load(folder_path + file_name)
			if texture is Texture2D:
				var key := file_name.get_basename()
				items[key] = texture

		elif file_name.get_extension() in ["res", "tres"]:
			var resource := load(folder_path + file_name)
			if resource is Texture2D:
				var key := file_name.get_basename()
				items[key] = resource
