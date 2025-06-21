extends Node
var picker = [null, null, null]
var slots = [null, null, null]
var states = ["empty", "sale", "sale"]
var active_slot = -1
var week_left = -1

func get_staff(budget, time):
	return Staff.new(budget, time)
	
func update_staff():
	week_left -= 1
	if week_left == 0:
		states[active_slot-1] = "done"
	
	for staff in slots:
		if staff:
			Season.money -= staff.get_wage()


func to_dict(list):
	var out = []
	for staff in list:
		if staff:
			out.append(staff.to_dict())
		else:
			out.append(staff)
	
	return out
	
func from_dict(list):
	var out = []
	for staff in list:
		if staff:
			out.append(Staff.new(0,0).from_dict(staff))
		else:
			out.append(null)
	
	return out

func get_mod(type):
	var tot = 0.0
	for staff in slots:
		if staff and staff.type == type:
			tot += staff.get_value()
	
	return 1.0 + (tot/100) 

class Staff:
	var type
	var staff_name
	var level = 0
	var types = ["Trainer", "Massuse", "Lawyer", "Doctor"]
	
	func _init(budget, time) -> void:
		staff_name = Game.name_generator()
		type = types[randi_range(0,len(types)-1)]
		var max = 0
		for i in range(time):
			var t = randf_range(budget/10, clamp((budget/10)+30, 0, 100))
			if t > level:
				level = t
				

	func print_wage():
		return "$" + str(get_wage()) + "/wk"
	
	func get_desc():
		if type == "Trainer":
			return str(get_value()) +"% increase in training"
		if type == "Massuse":
			return str(get_value()) + "% more energy recovered during rest"
		if type == "Doctor":
			return  str(get_value()) + "% increase in breeding success rate"
		if type == "Lawyer":
			return  str(get_value()) + "% lower auction starting price"
	
	func get_wage():
		return int(1000 * (level/100))
	
	func get_value():
		return int(20 * (level/100))
	
	func to_dict():
		var dict ={}
		dict["level"] = level
		dict["staff_name"] = staff_name
		dict["type"] = type
		
		return dict
		
	func from_dict(dict):
		level = dict["level"]
		staff_name = dict["staff_name"]
		type = dict["type"]
		return self
