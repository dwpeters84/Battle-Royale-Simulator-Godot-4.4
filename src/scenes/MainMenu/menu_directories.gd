extends PanelContainer

var target_url = "https://trello.com/b/cXJdfr6D/killing-fever-royale-roadmap"

func _on_cast_builder_pressed() -> void:
	get_tree().change_scene_to_file("uid://c62mvng83jemu")

func _on_map_builder_pressed() -> void:
	get_tree().change_scene_to_file("uid://d2yjq2dua1vf8")

func _on_road_map_pressed() -> void:
	open_url_in_browser(target_url)

func open_url_in_browser(url: String) -> void:
	
	if url.begins_with("http://") or url.begins_with("https://"):
		OS.shell_open(url)
