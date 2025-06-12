extends Control

var type

signal outcome(result: bool)

func setup(_type, message):
	type = _type
	$Panel/text.text = "[center]"+message+"[center]"
	$choice.visible = (type == "check_in")
	$Panel/Close.visible = (type != "check_in") 


func _no_pressed():
	outcome.emit(false)
	queue_free()
	
func _yes_pressed():
	outcome.emit(true)
	queue_free()


func _close_window():
	EventManager.flags[type] = true
	var parent = $Panel.get_parent()
	if parent:
		parent.queue_free()
