extends Label

func _physics_process(delta: float) -> void:
	set_text(str(int($"../HSlider".value)))
