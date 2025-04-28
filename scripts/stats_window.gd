extends Control

var horse: Horse



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func setup(horse_in: Horse):
	horse = horse_in
	$Panel/Head.play(horse.color)
	$Panel/Name.text = horse.horse_name
	$Panel/age.text = 'Age: ' + str(horse.age)
	$Panel/sex.text = 'Sex: ' + horse.sex
	$Panel/wins.text = 'Wins: ' + str(len(horse.wins))
	
	
	$Panel/VBoxContainer/Speed/SpeedBar.value = horse.stats['speed']
	$Panel/VBoxContainer/Stamina/StaminaBar.value = horse.stats['stamina']
	$Panel/VBoxContainer/Acceleration/AccBar.value = horse.stats['acceleration']
	$Panel/VBoxContainer/Vitality/VitalityBar.value = horse.stats['vitality']
	$Panel/VBoxContainer/Fertility/FertilityBar.value = horse.stats['fertility']
	
	$Panel/VBoxContainer/Speed/SpeedBar.tooltip_text = str(int(horse.stats['speed']))
	$Panel/VBoxContainer/Stamina/StaminaBar.tooltip_text = str(int(horse.stats['stamina']))
	$Panel/VBoxContainer/Acceleration/AccBar.tooltip_text = str(int(horse.stats['acceleration']))
	$Panel/VBoxContainer/Vitality/VitalityBar.tooltip_text = str(int(horse.stats['vitality']))
	$Panel/VBoxContainer/Fertility/FertilityBar.tooltip_text = str(int(horse.stats['fertility']))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_button():
	$Panel/auctionButton.visible = true


func _launch_auction():
	var scene = load("res://scenes/auction.tscn")
	var inst = scene.instantiate()
	
	get_tree().get_root().add_child(inst)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = inst
	
	get_tree().current_scene.start_auction(horse)


func _close_window():
	var parent = $Panel.get_parent()
	if parent:
		parent.queue_free()
