extends Node2D

var horse = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Tutorial.tutorial("race_screen")
	if Season.week > 1:
		Tutorial.tutorial("skip_race")
	var week = Season.week-1
	if Season.season == 1 and Season.week == 1:
		$SkipButton.visible = false
		
	$startButton.disabled = true
	$RacePanel/Race.text = Season.races[week].race_name
	$RacePanel/Length.text = str(Season.races[week].length) + 'm'
	$RacePanel/Purse.text = "$" + str(Season.races[week].purse)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if horse:
		$startButton.disabled = false

	




func set_horse(horse_ : Horse):
	horse = horse_
	$chooseHorse/horseName.text = "[center]" + horse_.horse_name + "[center]"	
	
	
	
func _start_race():
	var scene = load("res://scenes/race.tscn")
	var inst = scene.instantiate()
	get_tree().get_root().add_child(inst)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = inst
	get_tree().current_scene.setup(Season.week-1, horse)
	


func _skip_race():
	var scene = load("res://scenes/race.tscn")
	var inst = scene.instantiate()
	get_tree().get_root().add_child(inst)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = inst
	get_tree().current_scene.setup(Season.week-1)

	
func openSelector(type='race'):
	var selector_window =  preload("res://scenes/controls/selector.tscn")
	var window = selector_window.instantiate()
	window.new(type)
	var scene = get_tree().current_scene
	scene.add_child(window)
	
func _on_pressed():
	openSelector('race')
