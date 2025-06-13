extends Control

signal cont(result: bool)
signal choice(result: bool)

@onready var Horse = preload("res://scenes/entities/horse.tscn")

var event
var curr = 0

var text_speed = 2

var num_chars = 1

@onready var character = get_character()

func get_character():
	return str(randi_range(1, num_chars))


func setup(_event):
	event = _event
	$event.visible = true
	$message.visible = false
	$choice.visible = false
	character = str(event.character)
	$Scene/Person.play("idle2_" + character)
	await Game.pause(1)
	show_current_line()




func random_event(_encounter):
	var encounter = _encounter
	$message.visible = true
	$choice.visible = false
	$event.visible = false
	$Scene/Person.play("idle2_" + character)
	
	await print_line(encounter["intro"])
	$message/ContinueButton.disabled = false
	await cont
	$message.visible = false
	
	await print_line(encounter["question"])
	$choice.visible = true
	if await choice:
		$message.visible = true
		$message/ContinueButton.disabled = false
		await print_line(encounter["choices"]["yes"]["response"])
		await cont
		apply_effects(encounter["choices"]["yes"]["effects"])
	else:
		$message.visible = true
		$message/ContinueButton.disabled = false
		await print_line(encounter["choices"]["yes"]["response"])
		await cont
		apply_effects(encounter["choices"]["yes"]["effects"])
	
	end_scene()	


func print_line(msg):
	await print_msg(msg)
	await Game.pause(text_speed+1)
	$Scene/Person.play("idle1_" + character)


func show_current_line():
	await print_msg(event.convo[curr])
	await Game.pause(text_speed+1)
	$Scene/Person.play("idle1_" + character)
	$event/NextButton.disabled = false


func next():
	curr += 1
	$message/ContinueButton.disabled = true
	if curr == len(event.convo):
		end_scene()
	else:
		show_current_line()


func end_scene():
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")


func print_msg(msg):
	$Scene/Person.play("talking1_" + character)
	$pane/text.visible_ratio = 0
	$pane/text.text = "[center]" + msg + "[center]"	
	var tween = create_tween()
	tween.tween_property($pane/text, "visible_ratio", 1.0, text_speed).from(0.0)
	
	return true



func apply_effects(effects):
	for effect in effects:
		if effect["effect"] == "change_money":
			change_money(effect)
		elif effect["effect"] == "take_horse":
			take_horse(effect)
		elif effect["effect"] == "give_horse":
			give_horse(effect)
		elif "change" in effect["effect"]:
			change_stat(effect)

		



func change_money(effect):
	pass
	
func change_stat(effect):
	pass
	
func give_horse(effect):
	pass
	
func take_horse(effect):
	pass




func _ready():
	pass

func _continue():
	cont.emit(true)
	$message/ContinueButton.disabled = true
	
func _yes():
	choice.emit(true)
	$choice.visible = false
	
func _no():
	choice.emit(false)
	$choice.visible = false
	
func _next_pressed():
	next()
