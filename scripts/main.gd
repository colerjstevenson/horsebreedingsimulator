extends Node


func _ready():
	for horse in HorseManager.horses:
		add_child(horse)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
