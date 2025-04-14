extends TextureRect

func _ready():
	pass

func _on_accept_dialog_confirmed() -> void:
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	var img_link = %LinkInput.text
	add_child(http_request)
	http_request.connect("request_completed", _http_request_completed)

	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var error = http_request.request(img_link)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
# Called when the HTTP request is completed.

func _http_request_completed(result, response_code, headers, body):
	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")

	var new_texture = ImageTexture.new()
	var charimg = new_texture.create_from_image(image)

	texture = charimg


func _on_stream_image_pressed() -> void:
	%StreamImgPromp.popup()
	pass # Replace with function body.
