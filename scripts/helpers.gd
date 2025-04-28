extends Node



func pause(pause_time):
	await get_tree().create_timer(pause_time).timeout


func name_generator():
	var name = ""
	var rng = RandomNumberGenerator.new()
	
	#get first name
	var file = FileAccess.open("res://first-names.txt", FileAccess.READ)
	if file:
		var selected_line = ""
		var line_count = 0
		rng.randomize()
		while not file.eof_reached():
			var line = file.get_line().strip_edges()
			line_count += 1
			if rng.randi() % line_count == 0:
				selected_line = line
		file.close()
		name = selected_line + " "
	else:
		return "John Doe"

	#get last name
	file = FileAccess.open("res://last-names.txt", FileAccess.READ)
	if file:
		var selected_line = ""
		var line_count = 0
		
		rng.randomize()
		while not file.eof_reached():
			var line = file.get_line().strip_edges()
			line_count += 1
			if rng.randi() % line_count == 0:
				selected_line = line
		file.close()
		name += selected_line
	else:
		return "John Doe" + str(rng.randi())
		
		
	return name
