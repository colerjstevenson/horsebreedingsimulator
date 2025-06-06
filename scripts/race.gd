extends Control

var race_state

var length
var race_name
var prize
var week
var time

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
		print("WOOO")
		var player = rh_obj.instantiate()
		player.setup(_player, 5)
		player.set_pos(320, 660) # TODO: fix hard coding
		player.stand()
		add_child(player)
		horses.append(player)
	else:
		create_horse(5)
		launch_gambling()
	
	time = 0
	race_state = "READY"
	

func launch_gambling():
	$BettingScreen.visible = true
	for i in range(0,5):
		print(Casino.odds)
		print(horses)
		
		Casino.odds[i] = horses[i].horse.calc_horse_odds() #ERROR SOMEHOE??


func create_horse(pos):
	var rh = rh_obj.instantiate()
	rh.setup_new(5)
	rh.set_pos(320, clamp(480+(pos*45), 480, 660)) # TODO: fix hard coding
	rh.stand()
	add_child(rh)
	horses.append(rh)



func _plus_pressed(number):
	if Casino.horse[number] < 9900:
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
	Season.races[week].result = "L"
	
	if horses[-1].pos == leader:
		horses[-1].horse.wins.append(race_name)
		Season.money += prize
		Season.races[week].result = "W"
	
	for i in range(len(horses)):
		if horses[i].pos == leader:
			print("BET: " + str(i))
			Casino.settle_bets(i)
	
	Season.progressTime()
	get_tree().change_scene_to_file("res://scenes/main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if race_state == "RUNNING":
		time += delta
		update_horses()
		
	if $Track.position.x <= -1*($Track.size.x - get_viewport().size.x):
		race_state = "DONE"
		finish_race()
		
	if $BettingScreen.visible:
		for i in range(1, 6):
			find_child("horseBlock"+str(i)).find_child("text").text = "$" + str(Casino.horse[i-1])
			find_child("horseBlock"+str(i)).find_child("HorseName").text = horses[i-1].horse.horse_name
			find_child("horseBlock"+str(i)).find_child("odds").text = str(Casino.odds[i-1]) + ":1"
	
func update_horses():
	leader = 0
	for h in horses:
		var curr = h.get_pos(time)
		if curr > leader:
			leader = curr
	
	$Track.position.x = -1* ((leader*get_viewport().size.x)/100)
	
	for h in horses:
		h.update_pos(leader)
