extends VBoxContainer

var currently_linking: bool
var current_links: Array = []
@onready var option_nodes: Array = [%LinkConfirm, %LinkCancel]

signal linker

func _ready():
	add_to_group("AreaLinks")

func _on_pressed() -> void:
	if not currently_linking:
		emit_signal("linker",)
		currently_linking = true
	else:
		currently_linking = false
	get_tree().call_group("AreaLinks", "begin_linking")
	
func begin_linking():
	if currently_linking:
		option_nodes[0].disabled = true
	elif not currently_linking:
		option_nodes[1].disabled = true
	%NewAreaLink.disabled = true
	for node in option_nodes:
		node.show()
		
	for link in current_links:
		link.link_section.option_nodes[0].text = "Unlink area"

func _on_link_confirm_pressed() -> void:
	currently_linking = false
	emit_signal("linker")
	get_tree().call_group("AreaLinks", "stop_linking")

func _on_link_cancel_pressed() -> void:
	currently_linking = false
	get_tree().call_group("AreaLinks", "stop_linking")
	
func stop_linking():
	currently_linking = false
	%NewAreaLink.disabled = false
	
	for node in option_nodes:
		node.disabled = false
		node.hide()
