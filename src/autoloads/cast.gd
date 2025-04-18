extends Node

signal changed

var chara_dict = {}

var current_cast: Array = []:
	set(value):
		current_cast = value
		changed.emit()

func add_character(chara: Character):
	chara_dict["name"] = chara.char_name
	chara_dict["form"] = chara.form
	chara_dict["endurance"] = chara.endurance
	chara_dict["perception"] = chara.perception
	chara_dict["ingenuity"] = chara.ingenuity
	chara_dict["charisma"] = chara.charisma
	current_cast.append(chara)
