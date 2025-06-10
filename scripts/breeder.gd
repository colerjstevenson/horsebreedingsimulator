extends Node2D


var maleHorse = null
var femaleHorse = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BG/BreedingButton.disabled = true
	$BG/RightsButton.disabled = false
	$Breeding.visible = true
	$BreedingRights.visible = false
	
	if BreedingManager.breeder_state == "IP":
		$Breeding/BreedingScreen.visible = true
	
	if BreedingManager.breeder_state == "FAIL":
		$Breeding/FailedScreen.visible = true
		BreedingManager.breeder_state = "READY"
		
	if BreedingManager.breeder_state == "PREGO":
		$Breeding/PregoScreen/text.text = BreedingManager.mother.horse_name + " is pregnant!\nThey're expect to give birth at the end of the season!"
		$Breeding/PregoScreen.visible = true
		
	if BreedingManager.breeder_state == "DONE":
		$Breeding/NewHorseScreen.visible = true
		$Breeding/NewHorseScreen/TextEdit.text = BreedingManager.womb.horse_name
		$Breeding/NewHorseScreen/horseImg.play(BreedingManager.womb.color + "_left_standing")
		$Breeding/NewHorseScreen/text.text = BreedingManager.mother.horse_name + " gave birth!"
		
		if HorseManager.stalls == len(HorseManager.horses):
			$Breeding/NewHorseScreen/KeepButton.disabled = true
			$Breeding/NewHorseScreen/SellButton/warning.visible = true
		
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not femaleHorse:
		$Breeding/breederButtons/femaleSelector/femaleText.text = "[center]Select Mare[center]"	
		$Breeding/breederButtons/Preview/Female.visible = false
		for child in $Breeding/breederButtons/Preview/Stats.get_children():
			child.find_child("Female").visible =  false
	if not maleHorse:
		$Breeding/breederButtons/maleSelector/maleText.text = "[center]Select Stallion[center]"
		$Breeding/breederButtons/Preview/Male.visible = false
		for child in $Breeding/breederButtons/Preview/Stats.get_children():
			child.find_child("Male").visible =  false
			
	if not maleHorse or not femaleHorse:
		$Breeding/breederButtons/BreedButton.disabled = true
	else:
		$Breeding/breederButtons/BreedButton.disabled = false
		
	if not maleHorse and not femaleHorse:
		$Breeding/breederButtons/Preview/Stats.visible = false
	else:
		$Breeding/breederButtons/Preview/Stats.visible = true
	
	


func openMales():
	openSelector('Male')


func openFemales():
	openSelector('Female')


func openSelector(type='all'):
	print("WOOO")
	var selector_window =  preload("res://scenes/controls/selector.tscn")
	var window = selector_window.instantiate()
	window.new(type)
	var scene = get_tree().current_scene
	scene.add_child(window)
	
	
func set_males(horse: Horse):
	maleHorse = horse
	$Breeding/breederButtons/maleSelector/maleText.text = "[center]" + horse.horse_name + "[center]"
	$Breeding/breederButtons/Preview/Stats/Acceleration/Male.visible = true
	$Breeding/breederButtons/Preview/Stats/Speed/Male.visible = true
	$Breeding/breederButtons/Preview/Stats/Stamina/Male.visible = true
	$Breeding/breederButtons/Preview/Stats/Acceleration/Male.value = horse.stats["acceleration"]
	$Breeding/breederButtons/Preview/Stats/Speed/Male.value = horse.stats["speed"]
	$Breeding/breederButtons/Preview/Stats/Stamina/Male.value = horse.stats["stamina"]
	$Breeding/breederButtons/Preview/Male.visible = true
	$Breeding/breederButtons/Preview/Male.play(horse.color)
	
	
func set_females(horse: Horse):
	femaleHorse = horse
	$Breeding/breederButtons/femaleSelector/femaleText.text = "[center]" + horse.horse_name + "[center]"
	$Breeding/breederButtons/Preview/Stats/Acceleration/Female.visible = true
	$Breeding/breederButtons/Preview/Stats/Speed/Female.visible = true
	$Breeding/breederButtons/Preview/Stats/Stamina/Female.visible = true
	$Breeding/breederButtons/Preview/Stats/Acceleration/Female.value = horse.stats["acceleration"]
	$Breeding/breederButtons/Preview/Stats/Speed/Female.value = horse.stats["speed"]
	$Breeding/breederButtons/Preview/Stats/Stamina/Female.value = horse.stats["stamina"]
	$Breeding/breederButtons/Preview/Female.visible = true
	$Breeding/breederButtons/Preview/Female.play(horse.color)

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
	$Breeding/BreedingScreen.visible = true
	

func _random_pressed():
	$Breeding/NewHorseScreen/TextEdit.text = BreedingManager.womb.get_horse_name()


func _close_messgae():
	$Breeding/FailedScreen.visible = false
	
func _keep_pressed():
	BreedingManager.keep()
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
	

func _sell_pressed():
	BreedingManager.sell()
	
func _toggle_pressed(name):
	if name == "Breeding":
		$BG/BreedingButton.disabled = true
		$BG/RightsButton.disabled = false
		$Breeding.visible = true
		$BreedingRights.visible = false
	else:
		$BG/BreedingButton.disabled = false
		$BG/RightsButton.disabled = true
		$Breeding.visible = false
		$BreedingRights.visible = true

	
