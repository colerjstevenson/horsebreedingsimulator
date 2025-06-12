extends Control

var type

func setup(_type, message):
	type = _type
	$Panel/text.text = "[center]"+message+"[center]"




func _close_window():
	EventManager.flags[type] = true
	var parent = $Panel.get_parent()
	if parent:
		parent.queue_free()
