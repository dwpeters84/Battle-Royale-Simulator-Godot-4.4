extends Button

var save_file_path = "res://saves/"
var save_file_name
var load_file_name

var playerData = CastData.new()
var FuckYou

func _on_pressed() -> void:
	%Saver.popup()

func verify_save_directory(path : String):
	DirAccess.make_dir_absolute(path)
	
func save():
	print(save_file_path + save_file_name)
	ResourceSaver.save(playerData, save_file_path + save_file_name)

func _on_load_cast_pressed() -> void:
	%Loader.popup()
	
func loadcast():
	load_file_name = %Loader.get_current_file()
	var full_path = save_file_path + load_file_name
	if ResourceLoader.exists(full_path):
		playerData = ResourceLoader.load(full_path).duplicate(true)
		FuckYou = true
	else:
		print("Save file not found at path: ", full_path)
		FuckYou = false
		
func _on_saver_confirmed() -> void:
	save_file_name = %SaveName.text + ".tres"
	verify_save_directory(save_file_path)
	playerData.clear_cast(true)
	for child in %CharacterContainer.get_children():
		playerData.add_character(child)
	save()

func _on_loader_file_selected(path: String) -> void:
	
	for char in %CharacterContainer.get_children():
		char.queue_free()
	
	loadcast()
	
	if FuckYou:
		for char in playerData.cast:
			var scene = load("res://FighterCreator.tscn")
			var instance = scene.instantiate()
			%CharacterContainer.add_child(instance)
			
			instance.name_input.text = char["name"]
			var image = Image.load_from_file(char["imgpath"])
			instance.texture_rect.texture = ImageTexture.create_from_image(image)
			instance.texture_rect.texture.resource_path = char["imgpath"]
			instance.form_slider._on_value_changed(char["form"])
			instance.endurance_slider._on_value_changed(char["endurance"])
			instance.perception_slider._on_value_changed(char["perception"])
			instance.ingenuity_slider._on_value_changed(char["ingenuity"])
			instance.charisma_slider._on_value_changed(char["charisma"])
	elif not FuckYou:
		print("Fuck you")
	pass # Replace with function body.
