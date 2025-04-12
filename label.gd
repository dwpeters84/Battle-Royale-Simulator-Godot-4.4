extends Label

func _physics_process(delta: float) -> void:
	text = "Current Characters: " + str(int(Cast.current_cast.size()))
