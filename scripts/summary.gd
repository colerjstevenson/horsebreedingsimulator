extends Control


func _ready():
	var results =['DNF', '1st', '2nd', '3rd', '4th', '5th']
	
	
	$Result/amount.text = results[Season.raceResult]
	$Sales/amount.text = format_text(Season.auctionEarnings)
	$Race/amount.text = format_text(Season.raceEarnings)
	$Rights/amount.text = format_text(Season.breedingEarnings)
	$Gambling/amount.text = format_text(Season.gamblingEarnings)
	$Farm/amount.text = format_text(Season.farmSpending)
	
	var total = Season.farmSpending + Season.auctionEarnings + Season.breedingEarnings + Season.gamblingEarnings + Season.raceEarnings
	$total/amount.text = format_text(total)

func format_text(value):
	var text = ''
	if value < 0:
		text += '[color=red]-'
	elif value > 0:
		text += '[color=green]'
	
	text += '$' + str(abs(value))
	
	return text


func _on_pressed():
	Season.progressTime()
	Saves.save_game()
	if randf() < 0.15 and Season.week > 2:
		EventManager.random_event()
	else:
		get_tree().change_scene_to_file("res://scenes/mainMenu.tscn") 
