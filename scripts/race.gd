extends Control

var race_state

var length
var race_name
var prize
var week
var time
var skip

var horses = []
var leader

@onready var rh_obj =  preload("res://scenes/entities/raceHorse.tscn")

func setup(_week, _player=null):
	week = _week
	length = Season.races[week].length
	race_name = Season.races[week].race_name
	prize = Season.races[week].purse
	Season.races[week].horse = _player
	
	print(length)
	print(race_name)
	print(prize)
	
	$EndTile/text.text = "[center]" + str(length)
	
	var main_tile = $MainTile
	var finish_tile = $EndTile
	
	for x in range(0, length, 100):
		var new = main_tile.duplicate()
		new.get_child(0).text = "[center]" + str(x+100)
		new.visible = true
		$Track.add_child(new)
	
	var new = finish_tile.duplicate()
	new.visible = true
	$Track.add_child(new)
	
	# add horse to scene
	var scene = get_tree().current_scene
	
	for x in range(4):
		create_horse(x)
	
	#add player horse to the scene
	if _player:
		var player = rh_obj.instantiate()
		player.setup(_player, 5)
		player.print()
		player.set_pos(320, 660) # TODO: fix hard coding
		player.stand()
		add_child(player)
		horses.append(player)
		skip = false
		
	else:
		create_horse(5)
		skip = true
		launch_gambling()
	
	time = 0
	race_state = "READY"
	

func test():
	
	var race = Season.generate_race()
	
	length = race.length
	race_name = race.race_name
	prize = race.purse
	
	
	print(length)
	print(race_name)
	print(prize)
	
	$EndTile/text.text = "[center]" + str(length)
	
	var main_tile = $MainTile
	var finish_tile = $EndTile
	
	for x in range(0, length, 100):
		var new = main_tile.duplicate()
		new.get_child(0).text = "[center]" + str(x+100)
		new.visible = true
		$Track.add_child(new)
	
	var new = finish_tile.duplicate()
	new.visible = true
	$Track.add_child(new)
	
	# add horse to scene
	var scene = get_tree().current_scene
	
	for x in range(4):
		create_horse(x)
	
	#add player horse to the scene
	create_horse(5)
	skip = true
	
	time = 0
	race_state = "RUNNING"




func launch_gambling():
	set_horse_odds()
	$BettingScreen.visible = true
	


func create_horse(pos):
	var rh = rh_obj.instantiate()
	rh.setup_new(5)
	rh.set_pos(320, clamp(480+(pos*45), 480, 660)) # TODO: fix hard coding
	rh.stand()
	add_child(rh)
	horses.append(rh)



func _plus_pressed(number):
	if Casino.horse[number] < 9900 and Casino.horse.reduce(func(a, b): return a + b) < Season.money:
		Casino.horse[number] += 100


func _minus_pressed(number):
	if Casino.horse[number] > 0:
		Casino.horse[number] -= 100


func _place_bets():
	$BettingScreen.visible = false
 

func _start_race():
	race_state = "RUNNING"
	for h in horses:
		h.run()

	



func finish_race():
	
	if Tester.go:
		save_results()
		Tester.i +=1
		Season.progressTime()
		get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
	else:
		
		if skip:
			Season.races[week].result = "DNF"
			Season.races[week].horse = "skip"
		
		else:
			Season.raceResult = horses[-1].standing
			horses[-1].horse.fatigue()
		
		if horses[-1].standing == 1 and not skip:
			horses[-1].horse.wins.append(race_name)
			Season.money += prize
			Season.raceEarnings += prize
			Season.races[week].result = "W"
		
		for i in range(len(horses)):
			if horses[i].standing == 1:
				print("BET: " + str(i))
				Casino.settle_bets(i)
		get_tree().change_scene_to_file("res://scenes/Summary.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if race_state == "RUNNING":
		time += delta
		update_horses()
		
	if $Track.position.x <= -1*($Track.size.x - $Track/StartTile.size.x):
		print("done")
		race_state = "DONE"
		finish_race()
		
	if $BettingScreen.visible:
		for i in range(1, 6):
			find_child("horseBlock"+str(i)).find_child("text").text = "$" + str(Casino.horse[i-1])
			find_child("horseBlock"+str(i)).find_child("HorseName").text = horses[i-1].horse.horse_name
			find_child("horseBlock"+str(i)).find_child("odds").text = str(Casino.odds[i-1]) + ":1"



func update_horses():
	var race_scale = 75
	
	leader = 0
	for h in horses:
		var curr = h.get_pos(time)
		if curr > leader:
			leader = curr
	
	$Track.position.x = -1* ((leader*$Track/StartTile.size.x)/race_scale)
	
	for h in horses:
		h.update_pos(leader)
		update_standing(h)
				


func update_standing(horse):
	var count = 5
	for opponent in horses:
			if horse != opponent and opponent.get_pos(time) < horse.get_pos(time):
				count -= 1
	horse.standing = count

func map_range(value: float, in_min: float, in_max: float, out_min: float, out_max: float) -> float:
	if in_max == in_min:
		return out_min  # avoid division by zero
	return out_min + (out_max - out_min) * ((value - in_min) / (in_max - in_min))
	
	
func set_horse_odds():
	var properties = ["speed", "acceleration", "stamina"]
	var weights = {"speed": 0.3, "acceleration": 0.4, "stamina": 0.2}
	var horse_stats = [0,0,0,0,0]
	
	for i in range(len(horses)):
		var horse = horses[i]
		for value in properties:
			horse_stats[i] += horse.horse.stats[value] * weights[value]
		
	for i in range(len(horses)):
		Casino.odds[i] = int(map_range(horse_stats[i], horse_stats.min(), horse_stats.max(), 6, 2))



	

func save_results() -> void:
	# Open for read/write so it won't truncate existing data
	var file := FileAccess.open("res://scratchFiles/race_results.txt", FileAccess.READ_WRITE)
	if not file:
		push_error("Failed to open file")
		return

	# Move cursor to end so we append
	file.seek_end()
	var uid = ResourceUID.create_id()
	
	for h in horses:
		var text = ''
		text += str(uid) + ','
		text += str(length) + ','
		text += h.horse.horse_name + ','
		text += str(h.standing) + ','
		text += str(h.horse.stats['speed']) + ','
		text += str(h.speed) + ','
		text += str(h.horse.stats['acceleration']) + ','
		text += str(h.accel) + ','
		text += str(h.horse.stats["stamina"]) + ','
		text += str(h.endur) + ','
		text += str(h.horse.stats["energy"]) + '\n'
		
		# Append the text (without newline)
		#file.store_string(text)
		
	if Tester:
		for h in horses:
			Tester.standings.append(h.standing)
			Tester.speed.append(h.horse.stats['speed'])
			Tester.speed_r.append(h.speed)
			Tester.accel.append(h.horse.stats['acceleration'])
			Tester.accel_r.append(h.accel)
			Tester.stamina.append(h.horse.stats["stamina"])
			Tester.stamina_r.append(h.endur)
			Tester.energy.append(h.horse.stats["energy"])
	

	# Close to actually write to disk
	file.close()
