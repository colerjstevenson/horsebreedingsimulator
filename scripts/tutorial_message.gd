extends Control

func launch(msg):
	await Game.pause(1)
	await print_msg(msg)
	$Button.visible = true
	


func _clicked():
	var parent = $pane.get_parent()
	if parent:
		parent.queue_free()



func print_msg(msg):
	$Person.play("talking1_1")
	$pane/text.visible_ratio = 0
	$pane/text.text = "[center]" + msg + "[center]"	
	var tween = create_tween()
	tween.tween_property($pane/text, "visible_ratio", 1.0, Settings.text_speed).from(0.0)
	await Game.pause(Settings.text_speed+1)
	$Person.play("idle1_1")
