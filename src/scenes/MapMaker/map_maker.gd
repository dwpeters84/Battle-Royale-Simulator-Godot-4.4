extends Control

@onready var bgloader = %BGLoader

@onready var map: Array = []

func _on_new_area_area_passer(area: Variant) -> void:
	map.append(area.area_info)
	pass # Replace with function body.

func _on_print_map_pressed() -> void:
	print(map)
	pass # Replace with function body.

func update_map():
	pass
