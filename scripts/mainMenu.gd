extends Control
# Dictionary mapping button names to scene paths
var scene_paths = {
	"AuctionButton": "res://scenes/auctionMenu.tscn",
	"BreederButton": "res://scenes/breeder.tscn",
	"StableButton": "res://scenes/stable.tscn",
	"TrainerButton": "res://scenes/trainer.tscn",
	"RaceButton" : "res://scenes/raceSelector.tscn"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button_name in scene_paths.keys():
		var button = get_node(button_name)
		button.pressed.connect(_on_button_pressed.bind(button_name))


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
