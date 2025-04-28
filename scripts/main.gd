extends Node


func _ready():
	$MoneyLabel.text = "Money: " + str(HorseManager.money)
	
	$DateLabel.text = "[right]Season " + str(HorseManager.season) + "   Week " + str(HorseManager.week)
	for horse in HorseManager.horses:
		add_child(horse)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
