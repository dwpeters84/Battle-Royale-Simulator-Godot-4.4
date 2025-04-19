extends Button
signal load_bg
signal background_passer(bg)

var change_bg_toggle: bool

func _ready():
	var bgloader = get_tree().get_first_node_in_group("FileDialogs")
	bgloader.change_bg.connect(change_bg)
	pass

func _on_pressed() -> void:
	emit_signal("load_bg")
	change_bg_toggle = true
	pass # Replace with function body.

func change_bg(received_texture: Texture2D):
	
	if change_bg_toggle:
		%BgPreview.texture = received_texture
		emit_signal("background_passer", received_texture)
		change_bg_toggle = false
		
