extends Control

var BUTTON_SIZE = 150

var type

@onready var horse_list = $Selector/vBox


	

# Called when the node enters the scene tree for the first time.
func _ready():
	var cal_entry =  preload("res://scenes/controls/calenderCell.tscn")
	for r in Season.races:
		var cal_entry_inst =  cal_entry.instantiate()
		cal_entry_inst.setup(r)
		$Selector/vBox.add_child(cal_entry_inst)
	
	$Selector/vBox.size.y = $Selector/vBox.get_children().size() * BUTTON_SIZE
	
	return self


	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _close_window():
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
