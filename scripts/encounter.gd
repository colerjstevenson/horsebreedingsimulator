extends Control

@onready var Horse = preload("res://scenes/entities/horse.tscn")

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



func random_event():
	pass




func show_current_line():
	await print_msg(event.convo[curr])
	await Game.pause(text_speed+1)
	$Scene/Person.play("idle1_" + str(event.character))
	$NextButton.disabled = false


func next():
	curr += 1
	$NextButton.disabled = true
	if curr == len(event.convo):
		end_scene()
	else:
		show_current_line()


func _next_pressed():
	next()

func end_scene():
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")


func print_msg(msg):
	$Scene/Person.play("talking1_" + str(event.character))
	$pane/text.visible_ratio = 0
	$pane/text.text = "[center]" + msg + "[center]"	
	var tween = create_tween()
	tween.tween_property($pane/text, "visible_ratio", 1.0, text_speed).from(0.0)
	
	return true



# random Events

func traveling_salesman():
	
	var horse = Horse.instantiate()
	horse.setup()
	
	var intro = Game.get_greeting()
	intro += "I'm a traveling horse salesman and I've got just the horse for you! Just don't look in its mouth"
	
	
func juice_dealer():
	pass
	
	
func escaped_horse():
	pass
	

func horse_buyer():
	pass

	
