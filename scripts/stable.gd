extends Control

@onready var horse_list_container = $ScrollContainer/HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var door_entry =  preload("res://scenes/controls/HorseDoor.tscn")
	for h in HorseManager.horses:
		var door_entry_inst =  door_entry.instantiate()
		door_entry_inst.setup(h)
		horse_list_container.add_child(door_entry_inst)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
