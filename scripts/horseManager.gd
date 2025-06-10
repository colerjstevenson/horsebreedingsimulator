extends Node

var Horse = preload("res://scenes/entities/horse.tscn")

var stalls = 4

var horses = []
var store = []




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_horses()
	refresh_store()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# generate player horse for new game 
func setup_horses():
	for i in range(3):
		var horse_instance = Horse.instantiate()
		horse_instance.setup()
		horses.append(horse_instance)
	
	#ensures one of each	
	if horses[0].sex == horses[1].sex:
		if horses[0].sex == "Male":
			horses[0].sex = "Female"
		else:
			horses[0].sex = "Male"


func from_dict(horse):
	if not horse:
		return horse
	
	var inst = Horse.instantiate()
	inst.setup()
	inst.from_dict(horse)
	return inst
	
	


# generate new horse for the store
func refresh_store():
	store.clear()
	
	for i in range(4):
		var horse_instance = Horse.instantiate()
		horse_instance.setup()
		
		store.append(horse_instance)


# calculate the starting auction price of a horse
func calc_horse_price(horse: Horse):
	var base = 100
	var statFactor = 1.5
	var ageFactor = 100
	var winsFactor = 100
	
	var statsTotal = 0
	statsTotal += 2 * horse.stats['speed']
	statsTotal += 2 * horse.stats['acceleration']
	statsTotal += 2 * horse.stats['stamina']
	statsTotal += horse.stats['fertility']
	
	
	return clamp(int(base + (statsTotal*statFactor) - (horse.age*ageFactor) + (winsFactor*horse.wins.size())), 100, 2000)


 
