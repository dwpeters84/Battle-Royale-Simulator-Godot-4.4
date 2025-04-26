extends Control

@onready var bgloader = %BGLoader

@onready var map: Array = []

func _on_new_area_area_passer(area: Variant) -> void:
	map.append(area.area_info)

func _on_print_map_pressed() -> void:
	print(map)

func update_map():
	map.clear()
	for child in %AreaContainer.get_children():
		if child == %NewArea or child == %PrintMap:
			continue
		map.append(child.area_info)
	
func _on_new_area_map_updater(area_info: Variant) -> void:
	update_map()
	pass # Replace with function body.


#test
