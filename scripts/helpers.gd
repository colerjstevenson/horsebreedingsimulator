extends Node

var size: Vector2

func get_greeting():
	var greetings =[
		"Hey", "Hi", "Hello", "Yo", "Sup?", "Howdy", "Hiya", "What’s good?", "What’s poppin’?", "G’day",
		"Good morning", "Good afternoon", "Good evening", "Greetings", "How do you do?", "Pleasure to meet you",
		"Nice to see you", "It’s a pleasure", "Welcome", "I hope you're well",
		"Ahoy", "Top of the morning", "Yo yo yo", "Salutations", "‘Ello", "Heya sunshine", "Look who it is!",
		"Long time no see", "There you are!", "Well, if it isn’t my favorite person"
	]
	
	var rand1 = randi_range(0, len(greetings))
	
	var name_intros =[
		"My name is", "I'm", "I am", "The name is ", "It's me!", "They call me", 
		"You can call me", "My name is... umm...", "Why don't you call me"  
	]
	var rand2 = randi_range(0, len(name_intros))
	
	return greetings[rand1] + "! " + name_intros[rand2]+ " " + name_generator() + "!" 	
	

func pause(pause_time):
	await get_tree().create_timer(pause_time).timeout


func name_generator():
	var name = ""
	var rng = RandomNumberGenerator.new()
	
	#get first name
	var file = FileAccess.open("res://lists/first-names.txt", FileAccess.READ)
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
	file = FileAccess.open("res://lists/last-names.txt", FileAccess.READ)
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
