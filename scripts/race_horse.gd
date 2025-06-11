extends CharacterBody2D

#min and maxs for speed, acceleration, and endurance
var s_range = [10,22]
var a_range = [4,2]
var e_range = [2, 10]

var jiggle = 0.0

var t1
var t2
var t3

var N
var D


var horse:Horse
var horse_obj = preload("res://scenes/entities/horse.tscn")

var standing
var pos
var lane

var speed
var accel
var endur

func setup(_horse, _lane):
	horse = _horse
	lane = _lane
	pos = 0;
	z_index = _lane
	get_stats()

func setup_new(_lane):
	lane = _lane
	pos = 0;
	horse = horse_obj.instantiate()
	horse.setup_race()
	z_index = _lane
	get_stats()

func jiggle_range():
	pass

func convert_stat(stat, out_min, out_max):
	return (out_min + (out_max - out_min) * (stat/100.0))

func get_stats():
	speed = convert_stat(horse.stats["speed"], s_range[0], s_range[1]) * randf_range((horse.stats['vitality']/100.0), 1)
	endur = convert_stat(horse.stats["stamina"], e_range[0], e_range[1]) * randf_range((horse.stats['vitality']/100.0), 1)
	var accel_t = convert_stat(horse.stats["acceleration"], a_range[0], a_range[1]) * randf_range((horse.stats['vitality']/100.0), 1)
	
	accel = speed/accel_t
	
	N = (s_range[0])*(horse.stats["stamina"]/100) # minimum speed
	D = 6*(1.0 - (accel / 20.0))*(1.0 - (endur / 40.0)) # deacceleration
	
	# calculate phase durations
	t1 = (speed - N)/accel
	t2 = t1 + endur
	t3 = t2 + ((speed - N)/D)
	
	if horse.stats["vitality"] < 50:
		speed /= 2
		endur /= 2
		accel /= 2


func set_pos(x, y, z=-5):
	position.x = x
	position.y = y
	
func update_pos(leader):
	position.x = 320 - (((leader-pos)*get_viewport().size.x)/100)
	
	
func get_pos(time: float):
	var dist = (N*time + 0.5*accel*pow(time, 2))
	
	if time > t1:
		dist += speed * (time - t1)
		
	if time > t2:
		dist += clamp(speed*(time-t2) - 0.5*D*pow(time-t2, 2), 1, speed * (time - t1))
		
	if time > t3:
		dist += N*(time-t3)
		
	pos = dist
	
	return dist
	
	
func print():
	print("speed: " + str(speed))
	print("accel: " + str(accel))
	print("endur: " + str(endur))

	
func stand():
	$AnimatedSprite2D.play(horse.color + "_right_standing")
	
func run():
	$AnimatedSprite2D.play(horse.color + "_right_running")
