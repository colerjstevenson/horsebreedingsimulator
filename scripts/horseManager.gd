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
		
		if horses.all(func(h): return h.sex == "Female"):
			horse_instance.sex == "Male"
		if horses.all(func(h): return h.sex == "Male"):
			horse_instance.sex == "Female"
		
		horses.append(horse_instance)



# generate new horse for the store
func refresh_store():
	store.clear()
	
	for i in range(4):
		var horse_instance = Horse.instantiate()
		horse_instance.setup()
		
		store.append(horse_instance)


# calculate the starting auction price of a horse
func calc_horse_price(horse: Horse):
	var base = 0
	var statFactor = 2
	var ageFactor = 100
	var winsFactor = 100
	
	var statsTotal = 0
	for value in horse.stats.values():
		statsTotal += value
	
	return int(base + (statsTotal*statFactor) - (horse.age*ageFactor) + (winsFactor*horse.wins.size()))


	
