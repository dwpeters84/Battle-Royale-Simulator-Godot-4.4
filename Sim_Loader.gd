extends Node2D

var save_file_path = "user://save/"
var save_file_name = "Temp.Tres"
var cast = CastData.new()
@onready var MainGameController = get_tree().get_first_node_in_group("GameControllers")

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
		var image = Image.load_from_file(char["imgpath"])
		instance.texture_rect.texture = ImageTexture.create_from_image(image)
		instance.texture_rect.texture.resource_path = char["imgpath"]
		instance.form_slider._on_value_changed(char["form"])
		instance.endurance_slider._on_value_changed(char["endurance"])
		instance.perception_slider._on_value_changed(char["perception"])
		instance.ingenuity_slider._on_value_changed(char["ingenuity"])
		instance.charisma_slider._on_value_changed(char["charisma"])
		instance.pos.x = randi_range(0, MainGameController.map_size_maximum_x)
		instance.pos.y = randi_range(0, MainGameController.map_size_maximum_y)
		
	
func loadcast():
	var full_path = save_file_path + save_file_name
	if ResourceLoader.exists(full_path):
		cast = ResourceLoader.load(full_path).duplicate(true)
		return false
	else:
		print("Save file not found at path: ", full_path)
		return true
