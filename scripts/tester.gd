extends Node

var go = false
var test_num = 50

var standings = []
var stamina = []
var speed = []
var accel = []
var stamina_r = []
var speed_r = []
var accel_r = []
var energy = []
var i = 0


func _process(delta: float) -> void:
	if go and i > test_num:
		go = false
		print("speed: " + correlation(speed, standings))
		print("stamina: " + correlation(stamina, standings))
		print("accel: " + correlation(accel, standings))
		print("speed_r: " + correlation(speed_r, standings))
		print("stamina_r: " + correlation(stamina_r, standings))
		print("accel_r: " + correlation(accel_r, standings))
		print("energy: " + correlation(energy, standings))
		print(energy)
			




func run_race():
	for horse in HorseManager.horses:
		if horse.get_parent() != null:
			horse.get_parent().remove_child(horse)
	
	var scene = load("res://scenes/race.tscn")
	var inst = scene.instantiate()
	get_tree().get_root().add_child(inst)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = inst
	get_tree().current_scene.test()



func correlation(x_arr: Array, y_arr: Array) -> String:
	assert(x_arr.size() == y_arr.size())
	var a = nd.array(x_arr)
	var b = nd.array(y_arr)

	var mean_a = nd.mean(a)
	var mean_b = nd.mean(b)

	var a_c = nd.subtract(a, mean_a)
	var b_c = nd.subtract(b, mean_b)

	var cov = nd.mean(nd.multiply(a_c, b_c)).to_float()

	var std_a = nd.std(a).to_float()
	var std_b = nd.std(b).to_float()

	return str(cov / (std_a * std_b))
