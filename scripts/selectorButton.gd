extends Control

var horse: Horse


func setup(horse_in: Horse):
	horse = horse_in
	$Button/head.play(horse.color)
	$Button/name.text = horse.horse_name
	if horse.pregnant:
		$Button.disabled = true
		$Button/pregnant.visible = true
		
	return self


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _pressed():
	var parent = find_parent("SelectorWindow")
	
	if parent.type == "Male":
		parent.set_males(horse)
	elif parent.type == "Female":
		parent.set_females(horse)
	else:
		parent.set_horse(horse)
		
	
