extends Control

var save_file_path = "user://save/"
var save_file_name = "Temp.Tres"
var cast_logger = CastData.new()

func _on_start_game_dialog_confirmed() -> void:
	
	verify_save_directory(save_file_path)
	cast_logger.clear_cast(true)
	for child in %CharacterContainer.get_children():
		cast_logger.add_character(child)
	save()
	get_tree().change_scene_to_file("uid://c36oouwxqfmui")
	
func verify_save_directory(path : String):
	DirAccess.make_dir_absolute(path)
	
func save():
	ResourceSaver.save(cast_logger, save_file_path + save_file_name)
	
