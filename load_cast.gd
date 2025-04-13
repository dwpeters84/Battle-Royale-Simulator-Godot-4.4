extends Button

var save_file_path = "user://save/"
var save_file_name = "PlayerSave.Tres"

var playerData = CastData.new()

func _on_pressed() -> void:
	verify_save_directory(save_file_path)
	loadcast()
	for char in %CharacterContainer.get_children():
		queue_free()
	for path in playerData.cast:
		var scene = load(path)
		var instance = scene.instantiate()
		%CharacterContainer.add_child(instance)
	var cast_info = playerData.cast_info
	#for char in %CharacterContainer.get_children():
		##wtf do I put here

func verify_save_directory(path : String):
	DirAccess.make_dir_absolute(path)
	
func loadcast():
	var full_path = save_file_path + save_file_name
	if ResourceLoader.exists(full_path):
		playerData = ResourceLoader.load(full_path).duplicate(true)
	else:
		print("Save file not found at path: ", full_path)
