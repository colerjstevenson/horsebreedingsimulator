extends CharacterBody2D

#min and maxs for speed, acceleration, and endurance
var s_range = [20,16]
var a_range = [9,2]
var e_range = [10, 2]
var jiggle = 0.05

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
var stamina_s
var energy_boost

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

func convert_stat(stat, out_min, out_max):
	return out_min + (out_max - out_min) * (stat / 100.0)

func get_stats():
	 # Convert stats to physical values
	jiggle_range()
	speed = convert_stat(horse.stats['speed'], 5.0, 17.0)            # m/s
	accel = convert_stat(horse.stats['acceleration'], 0.2, 1.4)     # m/s²
	stamina_s = convert_stat(horse.stats['stamina'], 30.0, 120.0)   # seconds
	energy_boost = convert_stat(horse.stats['vitality'], 0.0, 5.0)    # m/s² additional accel

func get_pos(time: float):
	
	var eff_acc = accel + energy_boost * 0.1  # energy gives minor boost

	var t_to_top = speed / eff_acc if eff_acc > 0 else 0.0
	var dist
	if time <= t_to_top:
		dist = 0.5 * eff_acc * time**2
	else:
		dist = 0.5 * eff_acc * t_to_top**2 + speed * (time - t_to_top)

	# Fatigue: reduce performance past stamina threshold
	if time > stamina_s:
		dist *= (stamina_s / time)

	# Add ±5% randomness
	dist *= randf_range(1-jiggle, 1+jiggle)

	return dist


func set_pos(x, y, z=-5):
	position.x = x
	position.y = y
	
func update_pos(leader):
	position.x = 320 - (((leader-pos)*get_viewport().size.x)/100)
	
	
func stand():
	$AnimatedSprite2D.play(horse.color + "_right_standing")
	
func run():
	$AnimatedSprite2D.play(horse.color + "_right_running")
