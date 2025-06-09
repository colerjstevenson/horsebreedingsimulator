extends Node

var season_length = 8

var season
var week
var races = []

var money

var auctionEarnings
var gamblingEarnings
var raceEarnings
var breedingEarnings
var farmSpending
var raceResult

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	season = 1
	week = 1
	money = 1000
	refresh_season()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func generate_race(i=0):
	var length = randi_range(400, 1000)
	var rname = generate_name()
	var purse = randi_range(500, 2000)
	
	return Race.new(i, rname, length, purse)


func refresh_season():
	races.clear()
	for i in range(season_length-3):
		var length = randi_range(200, 1000)
		var rname = generate_name()
		var purse = randi_range(500, 2000)
		races.append(generate_race(i))
		
		
	races.append(Race.new(season_length-2, "Crown 1", 200, 3000, true))
	races.append(Race.new(season_length-1, "Crown 2", 600, 3000, true))
	races.append(Race.new(season_length, "Crown 3", 1200, 3000, true))
	auctionEarnings = 0
	gamblingEarnings = 0
	raceEarnings = 0
	breedingEarnings = 0
	farmSpending = 0
	raceResult = 0
	
	
	
	
func generate_name():
	var file = FileAccess.open("res://lists/horseRaces.txt", FileAccess.READ)
	if file:
		var selected_line = ""
		var line_count = 0
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		while not file.eof_reached():
			var line = file.get_line().strip_edges()
			line_count += 1
			if rng.randi() % line_count == 0:
				selected_line = line
		file.close()
		return selected_line
	return "horse"

func progressTime():
	week += 1
	auctionEarnings = 0
	gamblingEarnings = 0
	raceEarnings = 0
	breedingEarnings = 0
	farmSpending = 0
	raceResult = 0
	
	if week > season_length:
		week = 1
		season += 1
		for h in HorseManager.horses:
			h.age += 1
		
		BreedingManager.give_birth()
		
		refresh_season()
		
	HorseManager.refresh_store()
	BreedingManager.update_breeder()
	for h in HorseManager.horses:
		h.apply_training()
	



class Race:
	var length: int
	var race_name: String
	var purse: int
	var crown: bool
	var horse = null
	var result = null
	var week : int
	
	func _init(_week, _name, _len, _purse, _crown=false) -> void:
		length = _len
		race_name = _name
		purse = _purse
		crown = _crown
	
	
