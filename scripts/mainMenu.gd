extends Control

@onready var money = $MoneyLabel
@onready var date = $DateLabel


# Dictionary mapping button names to scene paths
var scene_paths = {
	"AuctionButton": "res://scenes/auctionMenu.tscn",
	"BreederButton": "res://scenes/breeder.tscn",
	"StableButton": "res://scenes/stable.tscn",
	"TrainerButton": "res://scenes/trainer.tscn",
	"RaceButton": "res://scenes/raceSelector.tscn",
	"Calender": "res://scenes/calender.tscn",
	"SettingsButton": "res://scenes/settingScreen.tscn"
}

func _setup():
	$MoneyLabel.text = "Money: " + str(Season.money)
	$DateLabel.text = "[right]Season " + str(Season.season) + "   Week " + str(Season.week)
	for horse in HorseManager.horses:
		add_child(horse)
	
	for button_name in scene_paths.keys():
		var button = find_child(button_name)
		button.pressed.connect(_on_button_pressed.bind(button_name))
	
	if Tester.go:
		Tester.i += 1
		await Game.pause(1)
		Tester.run_race()
		
	if Settings.tutorial:
		EventManager.run_intro()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("_setup")
	
	if not EventManager.flags["tired"]:
		for h in HorseManager.horses:
			if h.stats["vitality"] < 50:
				var msg = h.horse_name + " is looking tired... Consider letting them rest this week"
				EventManager.pop_up("tired", msg)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_button_pressed(button_name):
	var scene_path = scene_paths[button_name]
	if scene_path:
		for horse in HorseManager.horses:
			if horse.get_parent() != null:
				horse.get_parent().remove_child(horse)
		
		get_tree().change_scene_to_file(scene_path)
	else:
		print("No scene path found for button: ", button_name)


func _on_race_button_pressed() -> void:
	pass # Replace with function body.
