extends Node


func from_dict(dict):
	return Event.new(dict["convo"], dict["character"], dict["reward"])


class Event:
	var convo = []
	var character
	var reward
	
	func _init(_convo, _char, _reward):
		convo = _convo
		character = _char
		reward = _reward
