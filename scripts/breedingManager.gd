extends Node

var breeder_state
var womb
var weeks_left
var mother

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	breeder_state = "Ready"
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
	
	if breeder_state == "PREGO":
		if weeks_left == 0:
			breeder_state == "DONE"
			mother.pregnant = false
		
