extends Node2D

var horse

var go
var tiles = ["Tile1", "Tile2", "Tile3"]

var stat
var stats =  ["speed", "acceleration", "stamina"]


func _ready() -> void:
	Tutorial.tutorial("training_screen")
	stat = 0
	horse = null
	$horse.visible = false
	
	for h in HorseManager.horses:
		if h.training:
			set_horse(h)
			go = true
	
	var i = -745
	for tile in tiles:
		get_node(tile).position.y = -25
		get_node(tile).position.x = i
		i += 720


func _process(delta: float) -> void:
	$StatSelector/RichTextLabel.text = '[center]'+ stats[stat] +'[center]'
	if horse and not go:
		$StartButton.disabled = false
	else:
		$StartButton.disabled = true
	
	if go:
		$horse.run()
		for tile in tiles:
			get_node(tile).position.x -= 5
			
			if get_node(tile).position.x < -1080:
				get_node(tile).position.x = 1070

func set_horse(horse_ : Horse):
	horse = horse_
	$chooseHorse/horseName.text = "[center]" + horse_.horse_name + "[center]"
	
	$horse.setup(horse, 0)
	$horse.visible = true
	$horse.stand()



func openSelector(type='all'):
	var selector_window =  preload("res://scenes/controls/selector.tscn")
	var window = selector_window.instantiate()
	window.new(type)
	var scene = get_tree().current_scene
	scene.add_child(window)
	
func _on_selector_pressed():
	if not go:
		openSelector('All')	

func _start_pressed():
	go = true
	horse.training = stats[stat]

func _left_pressed():
	if not go:
		stat -= 1
		if stat < 0:
			stat = len(stats) - 1 


func _right_pressed():
	if not go:
		stat += 1
		if stat > len(stats) - 1:
			stat = 0
