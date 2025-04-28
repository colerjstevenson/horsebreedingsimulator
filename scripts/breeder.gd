extends Node2D


var maleHorse = null
var femaleHorse = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if BreedingManager.breeder_state == "IP":
		$BreedingScreen.visible = true
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not femaleHorse:
		$breederButtons/femaleSelector/femaleText.text = "[center]Select Mare[center]"	
	if not maleHorse:
		$breederButtons/maleSelector/maleText.text = "[center]Select Stallion[center]"
	
	if not maleHorse or not femaleHorse:
		$breederButtons/BreedButton.disabled = true
	else:
		$breederButtons/BreedButton.disabled = false


func openMales():
	openSelector('Male')


func openFemales():
	openSelector('Female')


func openSelector(type='all'):
	var selector_window =  preload("res://scenes/controls/selector.tscn")
	var window = selector_window.instantiate()
	window.new(type)
	var scene = get_tree().current_scene
	scene.add_child(window)
	
	
func set_males(horse: Horse):
	maleHorse = horse
	$breederButtons/maleSelector/maleText.text = "[center]" + horse.horse_name + "[center]"
	
func set_females(horse: Horse):
	femaleHorse = horse
	$breederButtons/femaleSelector/femaleText.text = "[center]" + horse.horse_name + "[center]"


func _breed_pressed():
	var h = preload("res://scenes/entities/horse.tscn")
	var inst = h.instantiate()
	inst = inst.breed(femaleHorse, maleHorse)
	
	if inst:
		BreedingManager.womb = inst
	else:
		print("horse shot blanks")
		
	BreedingManager.breeder_state = "IP"
	femaleHorse.pregnant = true
	BreedingManager.mother = femaleHorse
	$BreedingScreen.visible = true
	
	
	
