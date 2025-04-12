extends Button
signal load_bg


func _ready():
	var bgloader = get_tree().get_first_node_in_group("FileDialogs")
	bgloader.change_bg.connect(change_bg)
	pass

func _on_pressed() -> void:
	emit_signal("load_bg")
	pass # Replace with function body.

func change_bg(received_texture: Texture2D):
	print("WOOHOO")
	%BgPreview.texture = received_texture
	pass
