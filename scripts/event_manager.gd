extends Node
var flags = {
	"tired": false
}


var events_file = "res://lists/RandomEvent.json"

@onready var events = Saves.load_dict(events_file)




func run_intro():
	Settings.tutorial = false
	var convo = [
		"Howdy there, You must be the new owner! I'm Charles, I was your great uncle's lawyer and have been put in charge of his estate!",
		"This must have been a crazy week for you? To learn, not only that you have a long lost rich uncle, but that you've inherited his farm!",
		"And this isn't any old farm either! Here we breed top of the line thoroughbred race horses!",
		"The farm isn't what it used to be, but I think you're exactly what we need to turn this place around and get us back to our winning way!",
		"Along with the farm, your uncle also left you $1000 and his three remaining race horses get started!",
		"Best of the bunch is Old Chester! He's still got what it takes, but he's getting up there in years, most horses start to slow down at age 5",
		"If you want to bring the farm back to its former glory, you'll have to buy, breed, and train some horses of your own!",
		"Who knows, maybe some day you'll even have a horse that wins all three of the major races at the end of the season!",
		"That's what we call a Triple Crown! The most coveted prize in all of racing!",
		"Welp! That's enough of my yapping! You've got some work to do! Best of luck to ya!"
	]
	
	var reward = 0
	var character = 1
	
	for horse in HorseManager.horses:
			if horse.get_parent() != null:
				horse.get_parent().remove_child(horse)
	
	var scene = load("res://scenes/Encounter.tscn")
	var inst = scene.instantiate()
	get_tree().get_root().add_child(inst)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = inst
	get_tree().current_scene.setup(Event.new(convo, character, reward))



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
