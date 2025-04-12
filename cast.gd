extends Node

signal changed

var current_cast: Array = []:
	set(value):
		current_cast = value
		changed.emit()

func add_character(chara: Character):
	var chara_dict = {}
	chara_dict["name"] = chara.char_name
	chara_dict["form"] = chara.form
	chara_dict["endurance"] = chara.endurance
	chara_dict["perception"] = chara.perception
	chara_dict["ingenuity"] = chara.ingenuity
	chara_dict["charisma"] = chara.charisma