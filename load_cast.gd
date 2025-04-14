extends Button

var save_file_path = "user://save/"
var save_file_name = "PlayerSave.Tres"

var playerData = CastData.new()

func _on_pressed() -> void:

	verify_save_directory(save_file_path)
	loadcast()
	
	for char in %CharacterContainer.get_children():
		char.queue_free()
		
	for char in playerData.cast:
		var scene = load("res://FighterCreator.tscn")
		var instance = scene.instantiate()
		%CharacterContainer.add_child(instance)
		
		instance.name_input.text = char["name"] + "ABCDEFG"
		instance.texture_rect.texture = char["imgpath"]
		instance.form = char["form"]
		instance.endurance = char["endurance"]
		instance.perception = char["perception"]
		instance.ingenuity = char["ingenunity"]
		instance.charisma  = char["charisma"]
		
		print("Instance Form: ", instance.form)
		print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")

func verify_save_directory(path : String):
	DirAccess.make_dir_absolute(path)
	
func loadcast():
	var full_path = save_file_path + save_file_name
	if ResourceLoader.exists(full_path):
		playerData = ResourceLoader.load(full_path).duplicate(true)
	else:
		print("Save file not found at path: ", full_path)
