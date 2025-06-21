extends Control


func _ready():
	print(StaffManager.slots)
	for i in [1,2,3]:
		var block = find_child("StaffSlot" + str(i))
		if StaffManager.states[i-1] == "empty":
			block.find_child("text").text = "Start Staff Search"
			block.disabled = false
		if StaffManager.states[i-1] == "sale":
			block.find_child("text").text = "Unlock Slot $" + str(int(1000 * pow(2,i)))
			block.disabled = false
		if StaffManager.states[i-1] == "wait":
			block.find_child("text").text = "[center]Locked"
			block.disabled = true
		if StaffManager.states[i-1] == "search":
			block.find_child("text").text = "Search in Progress..."
			block.disabled = true
		if StaffManager.states[i-1] == "done":
			launch_picker()
		if StaffManager.states[i-1] == "full":
			
			var staff = find_child("StaffSlot"+str(i))
			staff.find_child("text").visible = false
			staff.find_child("name").visible = true
			staff.find_child("info").visible = true
			staff.find_child("logo").visible = true
			staff.find_child("wage").visible = true
			staff.find_child("name").text = StaffManager.slots[i-1].staff_name
			staff.find_child("info").text = StaffManager.slots[i-1].get_desc()
			staff.find_child("logo").play(StaffManager.slots[i-1].type)
			staff.find_child("wage").text = StaffManager.slots[i-1].print_wage()
		
		
func _process(delta: float) -> void:
	$Setup/Budget/text.text = "$" + str(int($Setup/BudgetSlider.value))
	$Setup/Time/text.text = str(int($Setup/TimeSlider.value)) + " weeks"

func _open_setup(slot):
	if StaffManager.states[slot-1] == "empty" and StaffManager.active_slot < 0:
		StaffManager.active_slot = slot
		$Setup.visible = true
	
	if StaffManager.states[slot-1] == "sale" and Season.money >= int(1000 * pow(2,slot)):
		Season.money -= int(1000 * pow(2,slot))
		StaffManager.states[slot-1] = "empty"
	
	
func _close_setup():
	$Setup.visible = false
	StaffManager.active_slot = -1
	
func _set_search():
	var block = find_child("StaffSlot" + str(StaffManager.active_slot))
	block.find_child("text").text = "Search in Progress..."
	block.disabled = true
	StaffManager.week_left = int($Setup/TimeSlider.value)
	StaffManager.states[StaffManager.active_slot-1] = "search"
	$Setup.visible = false
	Season.money -= $Setup/BudgetSlider.value

func _skip_picker():
	$Selector.visible = false
	StaffManager.states[StaffManager.active_slot-1] = "empty"
	StaffManager.active_slot = -1
	StaffManager.week_left = -1
	
func _pick(pick):
	StaffManager.slots[StaffManager.active_slot-1] = StaffManager.picker[pick]
	StaffManager.states[StaffManager.active_slot-1] = "full"
	
	$Selector.visible = false
	print("StaffSlot" + str(StaffManager.active_slot))
	var staff = find_child("StaffSlot" + str(int(StaffManager.active_slot)))
	staff.find_child("text").visible = false
	staff.find_child("name").visible = true
	staff.find_child("info").visible = true
	staff.find_child("logo").visible = true
	staff.find_child("wage").visible = true
	staff.find_child("name").text = StaffManager.picker[pick].staff_name
	staff.find_child("info").text = StaffManager.picker[pick].get_desc()
	staff.find_child("logo").play(StaffManager.picker[pick].type)
	staff.find_child("wage").text = StaffManager.picker[pick].print_wage()
	staff.disabled = true
	StaffManager.active_slot = -1
	_ready()

func launch_picker():
	$Selector.visible = true
	for i in [0,1,2]:
		if not StaffManager.picker[i]:
			StaffManager.picker[i] = StaffManager.get_staff($Setup/BudgetSlider.value, $Setup/TimeSlider.value)
		var staff = find_child("Employee"+str(i+1))
		staff.find_child("name").text = StaffManager.picker[i].staff_name
		staff.find_child("info").text = StaffManager.picker[i].get_desc()
		staff.find_child("logo").play(StaffManager.picker[i].type)
		staff.find_child("wage").text = StaffManager.picker[i].print_wage()
