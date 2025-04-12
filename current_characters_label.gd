extends Label

func _process(_delta: float) -> void:
	text = "Current Characters: " + str(int(Cast.current_cast.size()))
