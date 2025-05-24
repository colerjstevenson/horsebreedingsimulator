extends Node

var breeder_state
var womb
var weeks_left
var mother

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	breeder_state = "READY"
	womb = null
	weeks_left = 0
	mother = null


func update_breeder():
	if breeder_state == "IP":
		if not womb:
			breeder_state = "FAIL"
			mother.pregnant = false
			mother = null
		else:
			breeder_state = "PREGO"
	

func give_birth():
	if breeder_state == "PREGO":
		breeder_state == "READY"
		mother.pregnant = false
		HorseManager.horses.append(womb)
		
