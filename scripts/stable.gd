extends Control

@onready var horse_list_container = $ScrollContainer/HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh_list()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func refresh_list():
	for child in horse_list_container.get_children():
		child.queue_free()
	
	
	var door_entry =  preload("res://scenes/controls/HorseDoor.tscn")
	for h in HorseManager.horses:
		var door_entry_inst =  door_entry.instantiate()
		door_entry_inst.setup("HORSE", h)
		horse_list_container.add_child(door_entry_inst)
	
	for n in range(HorseManager.stalls - len(HorseManager.horses)):
		var door_entry_inst =  door_entry.instantiate()
		door_entry_inst.setup("EMPTY")
		horse_list_container.add_child(door_entry_inst)
		
	var door_entry_inst =  door_entry.instantiate()
	door_entry_inst.setup("BUY")
	horse_list_container.add_child(door_entry_inst)
