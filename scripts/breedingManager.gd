extends Node

var Horse = preload("res://scenes/entities/horse.tscn")

var breeder_state
var womb
var mother


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	breeder_state = "READY"
	womb = null #Horse.instantiate()
	#womb.setup()
	mother = null


func update_breeder():
	if breeder_state == "IP":
		if not womb:
			breeder_state = "FAIL"
			mother.pregnant = false
			mother = null
		elif breeder_state != "DONE":
			breeder_state = "PREGO"
	

func give_birth():
	if womb:
		breeder_state = "DONE"
		
		


func keep():
	HorseManager.horses.append(womb)
	womb = null
	breeder_state = "READY"
	mother.pregnant = false
	mother = null
	
	
func sell():
	var scene = load("res://scenes/auction.tscn")
	var inst = scene.instantiate()
	HorseManager.horses.append(womb)
	var tempWomb = womb
	womb = null
	mother.pregnant = false
	mother = null
	breeder_state = "READY"
	
	get_tree().get_root().add_child(inst)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = inst
	
	get_tree().current_scene.start_auction(tempWomb)
		


func loadBreeder(womb):
	if womb:
		womb = HorseManager.from_dict(womb)
		for horse in HorseManager.horses:
			if horse.pregnant:
				mother = horse
	
