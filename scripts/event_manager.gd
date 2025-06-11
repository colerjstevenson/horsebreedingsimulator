extends Node
var flags = {
	"tired": false
}

func from_dict(dict):
	return Event.new(dict["convo"], dict["character"], dict["reward"])


func pop_up(type, message):
	var stat_window =  preload("res://scenes/controls/PopUp.tscn")
	var window = stat_window.instantiate()
	window.setup(type, message)
	var scene = get_tree().current_scene
	scene.add_child(window)


func reset_flags():
	for key in flags.keys():
		flags[key] = false


class Event:
	var convo = []
	var character
	var reward
	
	func _init(_convo, _char, _reward):
		convo = _convo
		character = _char
		reward = _reward
