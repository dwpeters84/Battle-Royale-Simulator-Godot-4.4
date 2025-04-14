extends Node2D

var save_file_path = "user://save/"
var save_file_name = "Temp.Tres"
var cast = CastData.new()

func _ready():
	for char in %Characters.get_children():
		char.queue_free()
	
	loadcast()
		
	for char in cast.cast:
		var scene = load("res://FighterCreator.tscn")
		var instance = scene.instantiate()
		%Characters.add_child(instance)
		
		instance.custom_minimum_size.x = 190
		instance.set_char_name(char["name"])
		instance.toggle_ui(true)
		instance.texture_rect.texture = char["imgpath"]
		instance.form_slider._on_value_changed(char["form"])
		instance.endurance_slider._on_value_changed(char["endurance"])
		instance.perception_slider._on_value_changed(char["perception"])
		instance.ingenuity_slider._on_value_changed(char["ingenuity"])
		instance.charisma_slider._on_value_changed(char["charisma"])
		
	
func loadcast():
	var full_path = save_file_path + save_file_name
	if ResourceLoader.exists(full_path):
		cast = ResourceLoader.load(full_path).duplicate(true)
		return false
	else:
		print("Save file not found at path: ", full_path)
		return true
