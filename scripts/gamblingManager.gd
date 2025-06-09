extends Node

var horse = [0, 0, 0, 0, 0]
var odds = [99, 99, 99, 99, 99]



func _ready():
	clear_bets()


func clear_bets():
	horse[0] = 0
	horse[1] = 0
	horse[2] = 0
	horse[3] = 0
	horse[4] = 0




func settle_bets(winner):
	Season.gamblingEarnings = 0 - horse[0] - horse[1] - horse[2] - horse[3] - horse[4]
	
	match winner:
		0:
			Season.gamblingEarnings += 2 * horse[0]
		1:
			Season.gamblingEarnings += 2 * horse[1]
		2:
			Season.gamblingEarnings += 2 * horse[2]
		3:
			Season.gamblingEarnings += 2 * horse[3]
		4:
			Season.gamblingEarnings += 2 * horse[4]
		_:
			print("ERROR: umm... how did no one win...?")
		
	Season.money += Season.gamblingEarnings
	clear_bets()
