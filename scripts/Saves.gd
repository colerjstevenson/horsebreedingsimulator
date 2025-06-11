extends Node

var save_file = "user://save1.json"




func save_game():
	var file = FileAccess.open(save_file, FileAccess.WRITE)
	if file:
		print(ProjectSettings.globalize_path("user://"))
		file.store_string(JSON.stringify(make_dict()))
		file.close()
	else:
		print("ERROR: failed to save game")
	
	

func load_game():
	var dict = load_dict(save_file)
	if dict.is_empty():
		return
		
	#Settings
	Settings.difficulty = dict["difficulty"]
	
	#Season data
	Season.season = int(dict["season"])
	Season.week = int(dict["week"])
	Season.money = int(dict["money"])
	Season.races.clear()
	for race in dict["races"]:
		Season.races.append(Season.from_dict(race))
	
	#Horse Data
	HorseManager.stalls = int(dict["stalls"])
	HorseManager.horses.clear()
	for horse in dict["horses"]:
		HorseManager.horses.append(HorseManager.from_dict(horse))
	
	#Breeding Data
	BreedingManager.breeder_state = dict["breeder_state"]
	BreedingManager.loadBreeder(dict["womb"])


func load_dict(path: String):

	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		file = FileAccess.open(path, FileAccess.WRITE)
		push_error("Failed to open: %s" % path)
		return {}

	var json_text = file.get_as_text()
	file.close()

	# Parse JSON
	var json = JSON.new()
	var err = json.parse(json_text)
	if err != OK:
		push_error("JSON parse error @ %d: %s" % [json.get_error_line(), json.get_error_message()])
		return {}

	if typeof(json.data) != TYPE_DICTIONARY:
		push_error("%s did not contain a JSON object." % path)
		return {}

	return json.data



func make_dict():
	
	var dict = {}
	
	#Settings
	dict["difficulty"] = Settings.difficulty
	
	#Season data
	dict["money"] = Season.money
	dict["season"] = Season.season
	dict["week"] = Season.week
	dict["races"] = []
	for race in Season.races:
		dict["races"].append(race.to_dict())
	
	#Horse Data
	dict["stalls"] = HorseManager.stalls
	dict["horses"] = []
	for horse in HorseManager.horses:
		dict["horses"].append(horse.to_dict())
	
	#Breeding Data
	dict["breeder_state"] = BreedingManager.breeder_state
	if BreedingManager.womb:
		dict["womb"] = BreedingManager.womb.to_dict()
	else:
		dict["womb"] = BreedingManager.womb
		
	if BreedingManager.mother:
		dict["mother"] = BreedingManager.mother.to_dict()
	else:
		dict["mother"] = BreedingManager.mother
	
	
	return dict
