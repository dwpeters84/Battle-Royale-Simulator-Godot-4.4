extends Resource
class_name CastData

@export var cast: Array = []

func clear_cast(bool):
	if true:
		cast.clear()
	else:
		print("Fuck you")

func add_character(chara):
	var cast_info: Dictionary = {}
	cast_info = {
		"name": chara.char_name,
		"imgpath": chara.texture_rect.texture.resource_path,
		"form": chara.form_slider.stat_value,
		"endurance": chara.endurance_slider.stat_value,
		"perception": chara.perception_slider.stat_value,
		"ingenuity": chara.ingenuity_slider.stat_value,
		"charisma": chara.charisma_slider.stat_value
	}
	cast.append(cast_info)
