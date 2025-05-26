extends Node2D

var bid_increment = 50

var horse: Horse
var current_bid
var current_bidder

var player_sale

var no_bid_rounds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	current_bid = 0
	current_bidder = null
	no_bid_rounds = 0
	
	var entry =  preload("res://scenes/entities/bidder.tscn")
	for x in range(4):
		var entry_inst =  entry.instantiate()
		$Audience.add_child(entry_inst)

func start_auction(_horse: Horse):
	horse = _horse
	current_bid = floor(HorseManager.calc_horse_price(horse) / 100)*100
	
	player_sale = horse in HorseManager.horses
	$BidButton.visible = not player_sale
	$horseImg.play(horse.color + "_left_standing")
	print_msg("starting auction at $" + str(current_bid))
	await pause()
	await auction_loop()


func auction_loop():
	no_bid_rounds = 0
	
	while true:
		# give player chance to bid
		await pause()
		
		
		
		for bidder in $Audience.get_children():
			if bidder.should_bid(current_bid, horse, current_bidder):
				current_bid += bid_increment
				no_bid_rounds = 0
				current_bidder = bidder.bidder_name
				bidder.bid()
				print_msg(current_bidder + " bid $" + str(current_bid))
				break
		
		no_bid_rounds += 1
		match no_bid_rounds:
			3:
				print_msg("going once...")
				await pause()
			4:
				print_msg("going twice...")
				await pause()
			5:
				print_msg("sold for $" + str(current_bid) + " to " + current_bidder)
				end_auction()
			_:
				await pause()
		

func end_auction():
	await pause()
	if player_sale:
		Season.money += current_bid
		HorseManager.horses.erase(horse)
	else:
		if current_bidder == "PLAYER":
			HorseManager.horses.append(horse)
			Season.money -= current_bid
		HorseManager.store.erase(horse)
	get_tree().change_scene_to_file("res://scenes/main.tscn")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func player_bid():
	if Season.money >= current_bid+bid_increment and current_bidder != "PLAYER":
		current_bid += bid_increment
		current_bidder = "PLAYER"
		no_bid_rounds = 0
		print_msg("you bid $" + str(current_bid))


func pause():
	await Game.pause(2.0)
	
	
func print_msg(msg):
	$message.visible_ratio = 0
	$message.text = "[center]" + msg + "[center]"	
	var tween = create_tween()
	tween.tween_property($message, "visible_ratio", 1.0, 1.0).from(0.0)
