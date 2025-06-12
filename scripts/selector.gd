extends Control

var BUTTON_SIZE = 150

var type

@onready var horse_list = $Selector/vBox

func selector(horse: Horse):
	if type == 'Male':
		return horse.sex == 'Male' and horse.age != 0
	elif type == 'Female':
		return horse.sex == 'Female' and horse.age != 0
	elif type == "race":
		return not horse.pregnant and not horse.training and horse.age != 0
	else:
		return not horse.pregnant and not horse.training
	

# Called when the node enters the scene tree for the first time.
func _ready():
	return self

func new(type_):
	type = type_
	
	var horse_entry =  preload("res://scenes/controls/selectorButton.tscn")
	for h in HorseManager.horses:
		if selector(h):
			var horse_entry_inst =  horse_entry.instantiate()
			horse_entry_inst.setup(h)
			$Selector/vBox.add_child(horse_entry_inst)
	
	$Selector/vBox.size.y = $Selector/vBox.get_children().size() * BUTTON_SIZE
	
	return self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_males(horse):
	var parent = $Selector.get_parent()
	var scene = parent.get_tree().current_scene
	scene.set_males(horse)
	
	if parent:
		parent.queue_free()
		

func set_females(horse):
	var parent = $Selector.get_parent()
	var scene = parent.get_tree().current_scene
	scene.set_females(horse)
	
	if parent:
		parent.queue_free()
		

func set_horse(horse):
	var parent = $Selector.get_parent()
	var scene = parent.get_tree().current_scene
	scene.set_horse(horse)
	
	if parent:
		parent.queue_free()


func _close_window():
	var parent = $Selector.get_parent()
	if parent:
		parent.queue_free()
