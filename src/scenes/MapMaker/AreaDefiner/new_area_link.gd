extends Button

var currently_linking: bool
@onready var option_nodes: Array = [%LinkConfirm, %LinkCancel]

signal pass_links(links)

func _ready():
	add_to_group("AreaLinks")

func _on_pressed() -> void:
	if not currently_linking:
		add_to_group("CurrentlyLinking")
		currently_linking = true
	else:
		currently_linking = false
	get_tree().call_group("AreaLinks", "begin_linking")
	

	
func begin_linking():
	if currently_linking:
		option_nodes[0].disabled = true
	elif not currently_linking:
		option_nodes[1].disabled = true
	disabled = true
		
	for node in option_nodes:
		node.show()


func _on_link_confirm_pressed() -> void:
	if not currently_linking:
		add_to_group("CurrentlyLinking")
		
	get_tree().call_group("AreaLinks", "stop_linking")
	get_tree().call_group("CurrentlyLinking", "connect_links")



func _on_link_cancel_pressed() -> void:
	get_tree().call_group("AreaLinks", "stop_linking")
	
func stop_linking():
	currently_linking = false
	disabled = false
	
	for node in option_nodes:
		node.disabled = false
		node.hide()

func connect_links():
	for node in get_tree().get_nodes_in_group("CurrentlyLinking"):
		var newlabel = Label.new()
		%LinkContainer.add_child(newlabel)
		newlabel.text =	"Area linked!"
	emit_signal("pass_links", get_tree().get_nodes_in_group("CurrentlyLinking"))
	remove_from_group("CurrentlyLinking")
