extends Control

var event: EventManager.Event
var curr = 0

var text_speed = 2

func setup(_event):
	event = _event
	$Scene/Person.play("idle2_" + str(event.character))
	await Game.pause(1)
	show_current_line()


func _ready():
	pass


func show_current_line():
	await print_msg(event.convo[curr])
	await Game.pause(text_speed+1)
	$Scene/Person.play("idle1_" + str(event.character))
	$NextButton.disabled = false


func _next_pressed():
	curr += 1
	$NextButton.disabled = true
	if curr == len(event.convo):
		end_scene()
	else:
		show_current_line() 

func end_scene():
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")


func print_msg(msg):
	$Scene/Person.play("talking1_" + str(event.character))
	$pane/text.visible_ratio = 0
	$pane/text.text = "[center]" + msg + "[center]"	
	var tween = create_tween()
	tween.tween_property($pane/text, "visible_ratio", 1.0, text_speed).from(0.0)
	
	return true
	
