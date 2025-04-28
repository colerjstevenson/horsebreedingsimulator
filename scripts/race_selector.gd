extends Node2D

var horse = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_horse(horse_ : Horse):
	horse = horse_
	$chooseHorse/horseName.text = "[center]" + horse_.horse_name + "[center]"
	
	
	
func _start_race():
	var scene = load("res://scenes/race.tscn")
	var inst = scene.instantiate()
	get_tree().get_root().add_child(inst)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = inst
	get_tree().current_scene.setup(800, "bellmont_stakes", horse)
	
	
	
func openSelector(type='all'):
	var selector_window =  preload("res://scenes/controls/selector.tscn")
	var window = selector_window.instantiate()
	window.new(type)
	var scene = get_tree().current_scene
	scene.add_child(window)
	
func _on_pressed():
	openSelector('All')
