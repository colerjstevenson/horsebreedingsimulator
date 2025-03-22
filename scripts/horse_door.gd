extends TextureRect


var horse: Horse



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func setup(horse_in: Horse):
	horse = horse_in
	$Head.play(horse.color)
	$NameTag/NameTagText.text = "[center]" + horse.horse_name + "[center]"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
