extends VBoxContainer

var currently_linking: bool
var current_links: Array = []
@onready var option_nodes: Array = [%LinkConfirm, %LinkCancel]

signal linker
signal unlink(link_to_unlink)

var delete_link: bool

func _ready():
	add_to_group("AreaLinks")

func _on_pressed() -> void:
	if not currently_linking:
		emit_signal("linker")
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
		delete_link = true
		link.link_section.option_nodes[0].text = "Unlink area"

func _on_link_confirm_pressed() -> void:
	currently_linking = false

	#Check here if deleting link or not.
	if delete_link:
		var link_to_remove
		for node in get_tree().get_nodes_in_group("AreaBaseNode"):
			if node.link_section.currently_linking == true:
				print(node.areaname)
				if node == self:
					continue
				link_to_remove = node
			
		for tag in %LinkContainer.get_children():
			print(tag.text)
			
			if tag.text == link_to_remove.areaname:
				tag.queue_free()
	
		emit_signal("unlink", link_to_remove)
		delete_link = false
		
	else:
		emit_signal("linker")
		get_tree().call_group("AreaLinks", "stop_linking")

func _on_link_cancel_pressed() -> void:
	currently_linking = false
	get_tree().call_group("AreaLinks", "stop_linking")
	
func stop_linking():
	for node in option_nodes:
		node.disabled = false
		node.hide()
	currently_linking = false
	%NewAreaLink.disabled = false
