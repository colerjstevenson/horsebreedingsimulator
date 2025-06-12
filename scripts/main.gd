extends Control

@onready var game = preload("res://scenes/mainMenu.tscn")

func _ready():
	if not FileAccess.file_exists(Saves.save_file):
		$ColorRect/LoadGame.disabled = true
		



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_new_pressed():
	
	if FileAccess.file_exists(Saves.save_file):
		var msg = "Are you Sure? Starting a new game will delete your current save file."
		if not await EventManager.check_in(msg):
			return
	
	var src := FileAccess.open("res://saves/default.json", FileAccess.READ)
	var dst := FileAccess.open(Saves.save_file, FileAccess.WRITE)

	if src and dst:
		var data = src.get_buffer(src.get_length())
		dst.store_buffer(data)
		src.close()
		dst.close()
	else:
		print("ERROR: failed to load new game")
		get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
	
	Saves.load_game()
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
	


func _on_load_pressed():
	Saves.load_game()
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
	
