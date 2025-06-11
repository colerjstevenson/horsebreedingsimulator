extends Control

var event



func _ready():
	pass






func print_msg(msg):
	$message.visible_ratio = 0
	$message.text = "[center]" + msg + "[center]"	
	var tween = create_tween()
	tween.tween_property($message, "visible_ratio", 1.0, 1.0).from(0.0)
