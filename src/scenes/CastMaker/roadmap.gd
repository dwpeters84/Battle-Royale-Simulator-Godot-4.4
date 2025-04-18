extends Button
# Replace this with your desired link
var target_url: String = "https://trello.com/b/cXJdfr6D/killing-fever-royale-roadmap"

func _on_pressed() -> void:
	open_url_in_browser(target_url)

func open_url_in_browser(url: String) -> void:
	if url.begins_with("http://") or url.begins_with("https://"):
		OS.shell_open(url)
	else:
		push_error("Invalid URL: Must start with http:// or https://")
