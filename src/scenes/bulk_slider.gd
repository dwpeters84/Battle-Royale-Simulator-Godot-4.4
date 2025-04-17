extends HSlider


func _on_value_changed(_value:float) -> void:
	$Label.text = str(int(_value))
