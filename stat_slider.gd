@tool
extends HBoxContainer

signal value_changed(value: int)

@export_enum("form", "endurance", "perception", "ingenuity", "charisma") var modified_stat: String = "form":
	get:
		return modified_stat
	set(value):
		modified_stat = value
		update_label()

@export_range(1, 5, 1) var stat_value: int = 1:
	get:
		return stat_value
	set(value):
		stat_value = value
	#	slider.set_value_no_signal(float(stat_value))
		update_label()
		value_changed.emit(stat_value)

var label_stat: Label
var label_num: Label
var slider: Slider

func _ready():
	label_stat = get_node("%LabelStat")
	label_num = get_node("%LabelNum")
	slider = get_node("%Slider")
	update_label()
	slider.value_changed.connect(_on_value_changed)


func _on_value_changed(value: int):
	stat_value = int(value)
	update_label()


func update_label():
	if label_stat:
		label_stat.text = modified_stat
	if label_num:
		label_num.text = str(stat_value)
