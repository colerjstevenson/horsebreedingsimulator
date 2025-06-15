extends Node

var tracker = {
	"main_screen": true,
	"auction_screen": true,
	"race_screen": true,
	"breeding_screen": true,
	"training_screen": true, 
	"stable_screen": true,
	"stats_window": true,
	"skip_race": true,
}

var messages = {
	"main_screen": "Welcome to your first Season owning race horses! I'll be around to give some initial tips but have a look around first! Its all yours after all!",
	"auction_screen": "This is the auction house, where you can buy and sell horses! Horses are always sold by open autcion so the price is never gaurenteed, you can see the starting price but you'll have to outbid you competitors if you really want a horse!",
	"race_screen": "Here you can select the horse you'd like to enter in this weeks race! Starting the race ends the current week so be sure you're ready to move on before you start the race!",
	"breeding_screen": "Welcome to the breeding center! Here you can breed horses together to make new ones! Pregnancy takes several weeks and horses can't Race or train well pregnant, but if it succeeds, the new Fole will have a mix of stats from both parents!",
	"training_screen": "Here you can train horses to improve their stats! Training a horse will drain its enegery and it will not be elligible to race this week", 
	"stable_screen": "These are the stables where you can check out your horses! If you want more horses you'll need to buy more stalls for them! Click on a horse to see its stats!",
	"stats_window": "Each horse has 5 main stats:, SPEED: how fast they can go, ACCELERATION: how fast it gets to top speed, STAMINA: how long it can maintain that speed, ENGERY: goes down after racing and up after resting, tired horses often under perform, FERTILITY: how likely breeding is to succeed",
	"skip_race": "Notice you can also skip races if you don't want to enter a horse this week! If you skip a race you'll have the option to place bets on the race instead!"
}

func tutorial(type):
	if tracker[type]:
		tracker[type] =  false
		var pop_window =  preload("res://scenes/controls/TutorialMessage.tscn")
		var window = pop_window.instantiate()
		window.launch(messages[type])
		var scene = get_tree().current_scene
		scene.add_child(window)
