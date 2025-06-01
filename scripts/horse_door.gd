extends TextureRect


var horse: Horse
var type
var price


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func setup(_type, horse_in=null):
	type = _type
	horse = horse_in
	
	if type == "HORSE":
		$Head.play(horse.color)
		$NameTag/NameTagText.text = "[center]" + horse.horse_name + "[center]"
	elif type == "EMPTY":
		$Head.visible = false
		$NameTag/NameTagText.text = "[center] Empty [center]"
		$Button.disabled = true
	else:
		price = HorseManager.stalls * 100
		$Head.visible = false
		$NameTag/NameTagText.text = "[center]Purchase New Stables[center]"
		$Button.disabled = true
		$Buy.visible = true
		$Buy/price.text = "[center]$"+str(price)+"[center]"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed():
	var stat_window =  preload("res://scenes/controls/StatsWindow.tscn")
	var window = stat_window.instantiate()
	window.setup(horse)
	var scene = get_tree().current_scene
	scene.add_child(window)


func _buy_pressed():
	if price <= Season.money:
		print("WOOOOOOO")
		HorseManager.stalls += 1
		var scene = get_tree().current_scene
		scene.refresh_list()
		Season.money -= price
