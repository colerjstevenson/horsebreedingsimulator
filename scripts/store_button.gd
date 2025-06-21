extends Control

var horse : Horse

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func setup(h: Horse):
	horse = h
	var price = int(HorseManager.calc_horse_price(horse))
	
	$Name.text = "[center]" + horse.horse_name + "[center]"
	$Price.text = "[center]$" + str(price) + "[center]"
	$horseImg.play(horse.color + "_left_standing")
	


func _on_pressed():
	var stat_window =  preload("res://scenes/controls/StatsWindow.tscn")
	var window = stat_window.instantiate()
	window.setup(horse)
	window.show_button()
	var scene = get_tree().current_scene
	scene.add_child(window)
