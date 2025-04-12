extends Control


func _on_start_game_dialog_confirmed() -> void:
	get_tree().change_scene_to_file("res://Main.tscn")
