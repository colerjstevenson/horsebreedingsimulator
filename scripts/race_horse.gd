extends CharacterBody2D

#min and maxs for speed, acceleration, and endurance
var s_range = [16, 20]
var a_range = [2, 9]
var e_range = [2, 10]

var t1
var t2
var t3
var N
var D


var horse:Horse
var horse_obj = preload("res://scenes/entities/horse.tscn")

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
	horse.setup()
	z_index = _lane
	get_stats()

func jiggle_range():
	pass

func get_stats():
	jiggle_range()
	
	speed = s_range[0] + (horse.stats["speed"]/100) * (s_range[1] - s_range[0])
	endur = e_range[0] + (horse.stats["stamina"]/100) * (e_range[1] - e_range[0])
	var accel_t = a_range[0] + (horse.stats["acceleration"]/100) * (a_range[1] - a_range[0])
	accel = speed/accel_t
	
	N = s_range[0]/2 # minimum speed
	D = (accel/endur) # deacceleration
	
	# calculate phase durations
	t1 = (speed - N)/accel
	t2 = t1 + endur
	t3 = t2 + ((speed - N)/D)


func set_pos(x, y, z=-5):
	position.x = x
	position.y = y
	
func update_pos(leader):
	position.x = 320 - (((leader-pos)*get_viewport().size.x)/100)
	
	
func get_pos(time: float):
	var dist = N*time + 0.5*accel*pow(time, 2)
	
	if time > t1:
		dist += speed * (time - t1)
		
	if time > t2:
		dist += speed*(time-t2) - 0.5*D*pow(time-t2, 2)
		
	if time > t3:
		dist += N*(time-t3)
		
	pos = dist
	
	return dist
	
func stand():
	$AnimatedSprite2D.play(horse.color + "_right_standing")
	
func run():
	$AnimatedSprite2D.play(horse.color + "_right_running")
