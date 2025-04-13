extends Button

var save_file_path = "user://save/"
var save_file_name = "PlayerSave.Tres"

var playerData = CastData.new()

func _on_pressed() -> void:
	verify_save_directory(save_file_path)
	playerData.clear_cast(true)
	for child in %CharacterContainer.get_children():
		playerData.add_character(child)
	print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
	print(playerData.cast)
	print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")

func verify_save_directory(path : String):
	DirAccess.make_dir_absolute(path)
	
func save():
	ResourceSaver.save(playerData, save_file_path + save_file_name)


func _on_load_cast_pressed() -> void:
	for char in %CharacterContainer.get_children():
		char.queue_free()
		
	for char in playerData.cast:
		var scene = load("res://FighterCreator.tscn")
		var instance = scene.instantiate()
		%CharacterContainer.add_child(instance)
		
		instance.name_input.text = char["name"]
		instance.texture_rect.texture = char["imgpath"]
		instance.form = char["form"]
		instance.endurance = char["endurance"]
		instance.perception = char["perception"]
		instance.ingenuity = char["ingenuity"]
		instance.charisma = char["charisma"]
	
func loadcast():
	var full_path = save_file_path + save_file_name
	if ResourceLoader.exists(full_path):
		playerData = ResourceLoader.load(full_path).duplicate(true)
	else:
		print("Save file not found at path: ", full_path)
