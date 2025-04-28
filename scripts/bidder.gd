extends Control
class_name Bidder



var age_pref
var speed_pref: float
var accel_pref: float
var stam_pref: float
var aggressiveness: float # e.g. 0.8 - 1.3
var risk_tolerance: float # 0 - 1

var color: int
var bidder_name

func _init():
	age_pref = randf()
	speed_pref = randf()
	accel_pref = randf()
	stam_pref = randf()
	aggressiveness = randf()
	risk_tolerance = randf_range(0.8, 1.3)
	color = randi_range(1, 6)
	
	bidder_name = Game.name_generator()
	
	
func _ready():
	$Sprite.play("bidder" + str(color) + "_default")


func evaluate_horse(horse: Horse) -> float:
	var starting_price = HorseManager.calc_horse_price(horse)
	var randomness = randf_range(0.75, 1.25)
	# Weighted preference value for this horse
	var stats_pref = accel_pref*horse.stats["acceleration"] + speed_pref*horse.stats["speed"] + stam_pref*horse.stats["stamina"] - age_pref*horse.age 
	
	return (starting_price + (stats_pref*randomness))*risk_tolerance
	

func should_bid(current_bid: float, horse: Horse, current_bidder) -> bool:

	var horse_value = evaluate_horse(horse)

	if current_bid < horse_value and current_bidder != bidder_name:
		return true
	else:
		$Sprite.play("bidder" + str(color) + "_default")
		return false


func bid():
	$Sprite.play("bidder" + str(color) + "_active")
