extends Node2D


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
	pass
	
	
func _buy_pressed():
	$BuyButton.disabled = true
	$SellButton.disabled = false
	$Buy.visible = true
	
func _sell_pressed():
	$BuyButton.disabled = false
	$SellButton.disabled = true
	$Buy.visible = false
