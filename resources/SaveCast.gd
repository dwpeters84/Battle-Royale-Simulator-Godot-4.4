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
		"imgpath": chara.texture_rect.texture,
		"form": chara.form,
		"endurance": chara.endurance,
		"perception": chara.perception,
		"ingenuity": chara.ingenuity,
		"charisma": chara.charisma
	}
	cast.append(cast_info)
