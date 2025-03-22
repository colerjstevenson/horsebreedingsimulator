extends Node

var Horse = preload("res://scenes/horse.tscn")

var horses = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(3):
		var horse_instance = Horse.instantiate()
		horses.append(horse_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
