extends Resource
class_name CastData

@export var cast: Array = []
@export var cast_info: Dictionary = {}

func add_character(chara):
	cast.append(chara)
	cast_info[chara.char_name] = {
		"imgpath": chara.texture_rect.texture,
		"form": chara.form,
		"endurance": chara.endurance,
		"perception": chara.perception,
		"ingenuity": chara.ingenuity,
		"charisma": chara.charisma
	}
