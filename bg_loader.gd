extends FileDialog

signal change_bg(img)

func _on_file_selected(path: String) -> void:
	var image = Image.load_from_file(path)
	var texture = ImageTexture.create_from_image(image)
	change_bg.emit(texture)
