extends Node

var items: Dictionary

func _ready():
	var folder_path = "res://assets/textures/items/"
	var dir = DirAccess.open(folder_path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()

		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".png"):
				var file_path = folder_path + "/" + file_name
				var texture = Image.load_from_file(file_path)
				var itemtexture = ImageTexture.create_from_image(texture)	
				items[file_name.trim_suffix(".png")] = itemtexture
			file_name = dir.get_next()
		print(items)
		dir.list_dir_end()
