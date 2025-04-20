extends Button

var currently_linking: bool

signal start_link()

func _ready():
	add_to_group("AreaLinks")


func _on_pressed() -> void:
	currently_linking = true
	get_tree().call_group("AreaLinks", "begin_linking")
	
func begin_linking():
	%LinkOptions.show()
	pass
