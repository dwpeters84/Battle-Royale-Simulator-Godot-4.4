extends TextureRect

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
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")

	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")

	# Don't store the giant ass image itself
	image.resize(192, 192, Image.INTERPOLATE_LANCZOS)

	var base_dir = "res://" if OS.has_feature("editor") else OS.get_executable_path().get_base_dir()+"/"
	var img_path = base_dir + "avatars/streamed_img%05d.webp" % randi_range(0, 99999)
	# make sure the folder exists
	DirAccess.make_dir_recursive_absolute(img_path.get_base_dir())
	error = image.save_webp(img_path)
	if error != OK:
		push_error("Couldn't cache the streamed image.")

	texture = ImageTexture.create_from_image(image)
	texture.resource_path = img_path


func _on_stream_image_pressed() -> void:
	%StreamImgPromp.popup()
