extends Control

@onready var bgloader = %BGLoader

@onready var map: Array = []

func _on_new_area_area_passer(area: Variant) -> void:
	map.append(area.area_info)

func _on_print_map_pressed() -> void:
	print(map)

func update_map():
	print("Attempting to update map")

func _on_new_area_map_updater(area_info: Variant) -> void:
	update_map()
	pass # Replace with function body.
