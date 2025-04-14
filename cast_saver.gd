extends Button

var save_file_path = "user://save/"
var save_file_name = "PlayerSave.Tres"

var playerData = CastData.new()
var FuckYou

func _on_pressed() -> void:
	verify_save_directory(save_file_path)
	playerData.clear_cast(true)
	for child in %CharacterContainer.get_children():
		playerData.add_character(child)
	save()

func verify_save_directory(path : String):
	DirAccess.make_dir_absolute(path)
	
func save():
	ResourceSaver.save(playerData, save_file_path + save_file_name)

func _on_load_cast_pressed() -> void:
	for char in %CharacterContainer.get_children():
		char.queue_free()
	
	loadcast()
	
	if FuckYou:
		for char in playerData.cast:
			var scene = load("res://FighterCreator.tscn")
			var instance = scene.instantiate()
			%CharacterContainer.add_child(instance)
			
			instance.name_input.text = char["name"]
			instance.texture_rect.texture = char["imgpath"]
			instance.form_slider._on_value_changed(char["form"])
			instance.endurance_slider._on_value_changed(char["endurance"])
			instance.perception_slider._on_value_changed(char["perception"])
			instance.ingenuity_slider._on_value_changed(char["ingenuity"])
			instance.charisma_slider._on_value_changed(char["charisma"])
	elif not FuckYou:
		print("Fuck you")
	
func loadcast():
	var full_path = save_file_path + save_file_name
	if ResourceLoader.exists(full_path):
		playerData = ResourceLoader.load(full_path).duplicate(true)
		FuckYou = true
	else:
		print("Save file not found at path: ", full_path)
		FuckYou = false
