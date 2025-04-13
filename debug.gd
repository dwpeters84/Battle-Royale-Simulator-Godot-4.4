extends Button

var save_file_path = "user://save/"
var save_file_name = "PlayerSave.Tres"

var playerData = CastData.new()

func _on_pressed() -> void:
	verify_save_directory(save_file_path)
	for child in %CharacterContainer.get_children():
		playerData.cast.append(child)
	print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
	print(playerData.cast)
	print(playerData.cast_info)
	print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
	save()
	pass # Replace with function body.

func verify_save_directory(path : String):
	DirAccess.make_dir_absolute(path)
	
func save():
	ResourceSaver.save(playerData, save_file_path + save_file_name)
