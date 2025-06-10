extends Control

@onready var game = preload("res://scenes/mainMenu.tscn")

func _ready():
	if not FileAccess.file_exists(Saves.save_file):
		$ColorRect/LoadGame.disabled = true
		



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_new_pressed():
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")


func _on_load_pressed():
	Saves.load_game()
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
	
