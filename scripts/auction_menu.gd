extends Node2D

var horse

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	
	var entry =  preload("res://scenes/controls/store_button.tscn")
	for h in HorseManager.store:
		var entry_inst =  entry.instantiate()
		entry_inst.setup(h)
		$Buy/GridContainer.add_child(entry_inst)
		
	
	$BuyButton.disabled = true
	$SellButton.disabled = false
	$Buy.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if horse:
		$Sell/StartButton.disabled = false
	else:
		$Sell/StartButton.disabled = true
	
	
func _buy_pressed():
	$BuyButton.disabled = true
	$SellButton.disabled = false
	$Buy.visible = true
	$Sell.visible = false
	
func _sell_pressed():
	$BuyButton.disabled = false
	$SellButton.disabled = true
	$Buy.visible = false
	$Sell.visible = true


func openSelector(type='all'):
	var selector_window =  preload("res://scenes/controls/selector.tscn")
	var window = selector_window.instantiate()
	window.new(type)
	var scene = get_tree().current_scene
	scene.add_child(window)
	
func _on_selector_pressed():
	openSelector('All')
	
func _on_start_pressed():
	var scene = load("res://scenes/auction.tscn")
	var inst = scene.instantiate()
	
	get_tree().get_root().add_child(inst)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = inst
	
	get_tree().current_scene.start_auction(horse)
	
func set_horse(horse_ : Horse):
	horse = horse_
	$Sell/chooseHorse/horseName.text = "[center]" + horse_.horse_name + "[center]"
	
