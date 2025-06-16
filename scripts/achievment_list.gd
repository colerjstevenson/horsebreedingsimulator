extends Control

func _close():
	var parent = $BG/List.get_parent()
	if parent:
		parent.queue_free()



func _ready():
	for item in AchievmentManager.tracker.keys():
		if not AchievmentManager.tracker[item]:
			var cell = find_child(item)
			cell.modulate = Color(0.5, 0.5, 0.5, 1.0)
		
